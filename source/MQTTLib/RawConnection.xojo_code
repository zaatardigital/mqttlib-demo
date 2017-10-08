#tag Class
Protected Class RawConnection
	#tag Method, Flags = &h0
		Sub Close()
		  //-- Let's close the socket connection
		  
		  Self.pSocketAdapter.Disconnect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(inSocketAdapter As MQTTLib.SocketAdapter)
		  //-- Sets and patch the socket adapter
		  
		  // Cache a reference to the socket adpater
		  Self.pSocketAdapter = inSocketAdapter
		  
		  // A bit of wiring
		  inSocketAdapter.RegisterDelegates( _
		  WeakAddressOf Self.HandleSocketAdapterConnected, _
		  WeakAddressOf Self.HandleSocketAdapterNewData, _
		  WeakAddressOf Self.HandleSocketAdapterError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleSocketAdapterConnected()
		  //-- The socket layer is connected, connect to the MQTT broker
		  
		  Self.pConnected = True
		  RaiseEvent Connected
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleSocketAdapterError(inError AS MQTTLib.Error)
		  //-- There was an error with the socket adapter
		  
		  Dim theMessage As String = "Socket adapter error #" + Str( Integer( inError ) ) + "." 
		  
		  // In verbose mode, all errors are logged
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName + ": " + theMessage
		  
		  // Error always means disconnection
		  Self.pConnected =  False
		  
		  // Signal the subclass
		  RaiseEvent Error( theMessage, inError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleSocketAdapterNewData(inNewData As String)
		  //-- Process new incoming data
		  
		  Const kRemainingLengthValueMax = &b01111111
		  
		  // Assemble the remaining and the new data and cast the result to a MemoryBlock
		  Dim theRawData As MemoryBlock = Self.pDataRemainder + inNewData
		  
		  // This is the endless loop to process the raw data until there is no more complete packets
		  // There are exit conditions when no more data are avalaible or they are incomplete 
		  Do
		    
		    // A packet should at least be 2 bytes long 
		    If theRawData.Size < 2 Then
		      // Store the data and return
		      Self.pDataRemainder = theRawData
		      Return
		      
		    End If
		    
		    // ---- Compute the remaining length ----
		    
		    Dim theOffset As Integer = 1
		    Dim theMultiplier As Integer = 1
		    Dim theRemainingLentgh As Integer
		    Dim theByte As Byte
		    
		    Do
		      
		      // Check For not enough data
		      If theOffset >= theRawData.Size Then
		        // The data are incomplete
		        Self.pDataRemainder = theRawData
		        Return
		        
		      End If
		      
		      // Read the byte
		      theByte = theRawData.Byte( theOffset )
		      theOffset = theOffset + 1
		      
		      // Compute the value
		      theRemainingLentgh = theRemainingLentgh + ( theByte And kRemainingLengthValueMax ) * theMultiplier
		      
		      // Check for error
		      If theMultiplier > zd.Utils.Bits.kValueBit7^3 Then
		        // The fixed header is malformed, trigger a protocol error
		        Self.ProcessProtocolError( CurrentMethodName, "Malformed fixed header",  MQTTLib.Error.MalformedFixedHeader )
		        Return
		        
		      End If
		      
		      theMultiplier = theMultiplier * zd.Utils.Bits.kValueBit7
		      
		    Loop Until ( theByte And zd.Utils.Bits.kValueBit7 ) = 0 
		    
		    // ---- Calculate and check the block size needed to get a complete packet ----
		    
		    Dim thePacketSize As Integer = theOffset + theRemainingLentgh
		    If thePacketSize > theRawData.Size Then
		      // The data are incomplete
		      Self.pDataRemainder = theRawData
		      Return
		      
		    End If
		    
		    // We have enough data, extract them
		    Dim thePacketTypeAndFlag As UInt8 = theRawData.Byte( 0 )
		    Dim theOptionsData As MemoryBlock
		    If theRemainingLentgh > 0 Then theOptionsData = theRawData.MidB( theOffset, theRemainingLentgh )
		    
		    // Send the new Data
		    Try
		      RaiseEvent ControlPacketReceived New MQTTLib.ControlPacket( thePacketTypeAndFlag, theOptionsData )
		      
		    Catch e As MQTTLib.ProtocolException
		      // There was a problem when creating the ControlPacket
		      Self.ProcessProtocolError( CurrentMethodName, e.Message, e.ProtocolError )
		      Return
		      
		    End Try
		    
		    // Extract and store the remaining data if needed
		    If theRawData.Size < thePacketSize Then
		      Self.pDataRemainder = theRawData.RightB( theRawData.Size - thePacketSize )
		      
		    Else
		      // No data remaining
		      Self.pDataRemainder = ""
		      Return
		      
		    End If
		    
		    // Let's go for another round
		    theRawData = Self.pDataRemainder
		    
		  Loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub JettisonSocketAdapter()
		  //-- Unlink the socket adapter
		  
		  // Only if we have an existing socket adapter
		  If Not ( Self.pSocketAdapter Is Nil ) Then
		    // Unlink the socket adpaters delegates
		    Self.pSocketAdapter.RemoveDelegates
		    
		    // Destroy the socket adapater
		    Self.pSocketAdapter = Nil
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Open()
		  // Connect the socket adapter
		  
		  Self.pSocketAdapter.Connect
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessProtocolError(inMethodName As String, inMessage As String, inError As MQTTLib.Error)
		  //-- Process a protocol error
		  
		  // In verbose mode, all errors are logged
		  If MQTTLib.VerboseMode Then _
		  System.DebugLog inMethodName + ": " + inMessage + " *-* (#" + Str( Integer( inError ) ) + ")." 
		  
		  // A protocol error means the connection has to be closed.
		  // This will trigger a lost connection socket error
		  If Not ( Self.pSocketAdapter Is Nil ) Then Self.pSocketAdapter.Disconnect
		  
		  // Raise a well documented error event
		  RaiseEvent Error( inMessage, inError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendControlPacket(inPacket As MQTTLib.ControlPacket)
		  //-- Send the packet to the broker
		  
		  // --- Check the session state ---
		  If Not Self.Connected Then
		    Self.ProcessProtocolError( CurrentMethodName, "The socket adapter is not connected.", MQTTLib.Error.SocketAdapterNotConnected )
		    Return
		    
		  End If
		  
		  // We're clear to send
		  Self.pSocketAdapter.SendControlPacket inPacket
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Connected()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ControlPacketReceived(inControlPacket As MQTTLib.ControlPacket)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(inMessage As String, inError As MQTTLib.Error)
	#tag EndHook


	#tag Note, Name = Licensing
		MIT License
		
		Copyright (c) 2017 Za'atar Digital
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pConnected
			End Get
		#tag EndGetter
		Connected As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pConnected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pDataRemainder As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pDisconnecting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pSocketAdapter As MQTTLib.SocketAdapter
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Me.pSocketAdapter
			End Get
		#tag EndGetter
		SocketAdapter As MQTTLib.SocketAdapter
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Connected"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
