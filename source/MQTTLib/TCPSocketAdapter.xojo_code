#tag Class
Protected Class TCPSocketAdapter
Implements SocketAdapter
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub Connect()
		  //-- Part of the MQTTLib.SocketAdapter interface
		  // Connect the TCP Socket
		  
		  pTCPSocket.Connect
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(inTCPSocket As TCPSocket)
		  // Store the TCPSocket reference
		  
		  pTCPSocket = inTCPSocket
		  
		  AddHandler inTCPSocket.Connected, WeakAddressOf HandleTCPSocketConnected
		  AddHandler inTCPSocket.DataAvailable, WeakAddressOf HandleTCPSocketIncomingData
		  AddHandler inTCPSocket.Error, WeakAddressOf HandleTCPSocketError
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub Disconnect()
		  //-- Part of the MQTTLib.SocketAdapter interface
		  // Disconnect the TCP Socket
		  
		  // This will reset the socket and trigger a TCPSocket.Error with a TCPSocket.LostConnection code (102).
		  pTCPSocket.Disconnect
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleTCPSocketConnected(inTCPSocket As TCPSocket)
		  //-- Handle the TCP connection of the socket.
		  
		  #Pragma Unused inTCPSocket
		  
		  If Not ( Self.pConnectedDelegate Is Nil ) Then pConnectedDelegate.Invoke
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleTCPSocketError(inTCPSocket As TCPSocket)
		  //-- Handles the TCPSocket.Error event
		  
		  // Retrieve and translate the error code
		  Dim theError As MQTTLib.Error
		  Select Case inTCPSocket.LastErrorCode
		    
		  Case SocketCore.NoError
		    theError = MQTTLib.Error.NoError
		    
		  Case SocketCore.LostConnection
		    theError = MQTTLib.Error.LostConnection
		    
		  Case SocketCore.AddressInUseError
		    theError = MQTTLib.Error.AddressInUse
		    
		  Case SocketCore.InvalidPortError
		    theError = MQTTLib.Error.InvalidPort
		    
		  Case SocketCore.OutOfMemoryError
		    theError = MQTTLib.Error.OutOfMemory
		    
		  Case SocketCore.InvalidStateError
		    theError = MQTTLib.Error.SocketInvalidState
		    
		  Case SocketCore.NameResolutionError
		    theError = MQTTLib.Error.CantResolveAddress
		    
		  Else
		    theError = MQTTLib.Error.Unknown
		    
		  End Select
		  
		  // Signal the error to the MQTT instance
		  If Not ( pErrorDelegate Is Nil ) Then Self.pErrorDelegate.Invoke( theError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandleTCPSocketIncomingData(inTCPSocket As TCPSocket)
		  //-- Transfer the new data to the MQTT instance
		  
		  If Not ( Self.pIncomingDataDelegate Is Nil ) Then Self.pIncomingDataDelegate.Invoke( inTCPSocket.ReadAll )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub RegisterDelegates(inConnectedDelegate AS MQTTLib.SocketAdapterConnectedDelegate, inIncomingDataDelegate AS MQTTLib.SocketAdapterIncomingDataDelegate, inErrorDelegate AS MQTTLib.SocketAdapterErrorDelegate)
		  //-- Part of the MQTTLib.SocketAdapter interface
		  // Register the delegates to interface with the MQTT connector
		  
		  pConnectedDelegate = inConnectedDelegate
		  pIncomingDataDelegate = inIncomingDataDelegate
		  pErrorDelegate = inErrorDelegate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub RemoveDelegates()
		  //-- Part of the MQTTLib.SocketAdapter interface
		  // Unplug all the registered delegates
		  
		  pConnectedDelegate = Nil
		  pIncomingDataDelegate = Nil
		  pErrorDelegate = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub SendControlPacket(inControPacket As MQTTLib.ControlPacket)
		  //-- Get the data from the control packet and send them at once.
		  // Part of the MQTTLib.SocketAdapter interface
		  
		  pTCPSocket.Write inControPacket.RawData
		End Sub
	#tag EndMethod


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


	#tag Property, Flags = &h21
		Private pConnectedDelegate As MQTTLib.SocketAdapterConnectedDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pErrorDelegate As MQTTLib.SocketAdapterErrorDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pIncomingDataDelegate As MQTTLib.SocketAdapterIncomingDataDelegate
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private pTCPSocket As TCPSocket
	#tag EndProperty


	#tag ViewBehavior
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
