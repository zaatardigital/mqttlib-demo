#tag Class
Protected Class ClientConnection
	#tag Method, Flags = &h21
		Private Sub ClearSession()
		  //-- Clear the session after a disconnection
		  
		  Self.pConnected = False
		  
		  // Stop the timers
		  Self.pPeriodicCheckTimer.Mode = Timer.ModeOff
		  Self.pKeepAliveTimer.Mode = Timer.ModeOff
		  
		  // Clear the dictionaries
		  Self.pPacketsAwaitingResponse.RemoveAll
		  Self.pPacketsAwaitingResponseTimeout.RemoveAll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Connect()
		  //-- Initiates the connection process by opening the raw connection
		  // The next step will occured in the HandleRawConnectionConnected() method
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  Self.pRawConnection.Open
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  //-- Initialize the basic stuff
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Create the sent packet dictionary
		  Self.pPacketsAwaitingResponse = New Xojo.Core.Dictionary
		  Self.pPacketsAwaitingResponseTimeout = New Xojo.Core.Dictionary
		  
		  // Create the keep alive timer
		  Self.pKeepAliveTimer = New Timer
		  
		  // and wire it
		  AddHandler Self.pKeepAliveTimer.Action, WeakAddressOf Self.HandleKeepAliveTimerAction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disconnect()
		  //-- Disconnect the broker
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  If Not ( Self.pRawConnection Is Nil ) Then Self.pRawConnection.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleKeepAliveTimerAction(inTimer As Timer)
		  #pragma Unused inTimer
		  
		  // As simple as this
		  Self.PingBroker
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandlePeriodicCheck(inTimer As Timer)
		  
		  // Go through all stored packet to check if they ar all still valid
		  Dim theTime As Double = Microseconds
		  
		  For Each entry As Xojo.Core.DictionaryEntry In Self.pPacketsAwaitingResponseTimeout
		    
		    If entry.Value < theTime Then
		      // Retrieve the packet
		      Dim thePacket As MQTTLib.ControlPacket = Self.pPacketsAwaitingResponse.Value( entry.Key )
		      Dim thePacketID As UInt16 = entry.key
		      
		      // We have a timed out packet
		      Self.ProcessProtocolError( CurrentMethodName, "A " + thePacket.TypeString + " packet with ID " + Str(  thePacketID ) + " has timed out.", MQTTLib.Error.TimedOut )
		      Return
		      
		    End If
		    
		  Next
		  
		  // All is good... for now!
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandlePINGTimedOut()
		  //-- The last ping has timed out
		  Static theCallCount As Integer
		  
		  theCallCount = theCallCount + 1
		  If theCallCount = 2 then Break 
		  Self.ProcessProtocolError( CurrentMethodName, Str( theCallCount ) + " - No response from the broker when pinged.", MQTTLib.Error.PINGTimedOut )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionConnected(inRawConnection As MQTTLib.RawConnection)
		  //-- The socket adapter is connected, let's open the MQTT connection
		  
		  #Pragma Unused inRawConnection
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Create the CONNECT control packet with the options passed to the constructor
		  Dim theCONNECTPacket As New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.CONNECT, Self.pConnectionSetup )
		  
		  // Send the packet
		  Self.SendControlPacket theCONNECTPacket
		  
		  // Store the time it was sent
		  Self.pPacketsAwaitingResponse.Value( kCONNECTDictionaryKey ) = Microseconds
		  
		  // Start the periodic checker timer
		  Self.pPeriodicCheckTimer.Mode = Timer.ModeMultiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionControlPacketReceived(inRawConnection As MQTTLib.RawConnection, inControlPacket As MQTTLib.ControlPacket)
		  //-- A new control packet is available
		  
		  #Pragma Unused inRawConnection
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  Select Case inControlPacket.Type
		    
		  Case MQTTLib.ControlPacket.Type.CONNACK
		    Self.ProcessCONNACK( MQTTLib.OptionsCONNACK( inControlPacket.Options ) )
		    
		  Case MQTTLib.ControlPacket.Type.PINGRESP
		    Self.ProcessPINGRESP
		    
		  Case MQTTLib.ControlPacket.Type.SUBACK
		    Self.ProcessSUBACK( MQTTLib.OptionsSUBACK( inControlPacket.Options ) )
		    
		  Case MQTTLib.ControlPacket.Type.PUBLISH
		    Self.ProcessPUBLISH MQTTLib.OptionsPUBLISH( inControlPacket.Options )
		    
		  Case MQTTLib.ControlPacket.Type.PUBACK
		    Self.ProcessPUBACK MQTTLib.OptionsPUBACK( inControlPacket.Options )
		    
		  Else
		    Self.ProcessProtocolError( CurrentMethodName, "Unsupported control packet type #" _
		    + Str( Integer( inControlPacket.Type ) ) + ".", MQTTLib.Error.UnsupportedControlPacketType )
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionError(inRawConnection As MQTTLib.RawConnection, inMessage As String, inError As MQTTLib.Error)
		  //-- Handles an error from the raw connection
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Clear the session state if we are still connected
		  If Self.pConnected = True Then Self.ClearSession
		  
		  // Signal the error to the subclass
		  RaiseEvent Error( inMessage, inError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleResponseTimeOut()
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewPacketID() As UInt16
		  //-- Generate a non-zero unused packetID.
		  
		  #Pragma DisableBackgroundTasks
		  
		  Do
		    
		    // ** Note **
		    // There is a possibility that this loop turn into an endless one.
		    // but it is unlikely that 65535 packetIDs are used at the same time.
		    
		    // Increment the counter to the next ID
		    Self.pPacketIDCounter = Self.pPacketIDCounter + 1
		    
		    // PacketID are non-zero.
		    If pPacketIDCounter = 0 Then Self.pPacketIDCounter = 1
		    
		    // If this packetID is already used, try the next one.
		  Loop Until Not Self.pPacketsAwaitingResponse.HasKey( Self.pPacketIDCounter ) 
		  
		  // Return the new unused packet
		  Return Self.pPacketIDCounter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PingBroker()
		  //-- Send a PING to the broker.
		  
		  // Give Me a ping, Vassily. One ping only, please.
		  Self.SendControlPacket( New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.PINGREQ ) )
		  
		  // Set a delayed call for timeout
		  Xojo.Core.Timer.CallLater( Self.pControlPacketTimeToLive, AddressOf Self.HandlePINGTimedOut )
		  
		  System.DebugLog CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessCONNACK(inOptions As MQTTLib.OptionsCONNACK)
		  //-- Process the received CONNACK control packet
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Is the connection accepted?
		  If inOptions.ReturnCode = MQTTLib.OptionsCONNACK.kReturnCodeConnectionAccepted Then
		    // We are connected to the MQTT broker
		    pConnected = True
		    
		    // Arm the keep alive timer
		    Self.pKeepAliveTimer.Mode = Timer.ModeSingle
		    If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName + ": Broker connected"
		    
		    RaiseEvent BrokerConnected( inOptions.SessionPresentFlag )
		    
		  Else
		    // The connection has been refused by the broker
		    // It also means that the broker closed the connection
		    // But it cant't hurt to close on our side
		    If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName+  ": BrokerConnection rejected with code #" _
		    + Str( inOptions.ReturnCode ) + "."
		    
		    Self.pRawConnection.Close
		    RaiseEvent BrokerConnectionRejected( inOptions.ReturnCode )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPINGRESP()
		  // Remove the PINGRESP timeout timer
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  Xojo.Core.Timer.CancelCall( WeakAddressOf Self.HandlePINGTimedOut )
		  
		  RaiseEvent ReceivedPINGRESP
		  
		  // rearm the keep alive timer
		  Self.pKeepAliveTimer.Mode = Timer.ModeSingle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessProtocolError(inMethodName As String, inMessage As String, inError As MQTTLib.Error)
		  // An error means the connection has to be closed
		  Self.Disconnect
		  
		  // In verbose mode, all errors are logged
		  If MQTTLib.VerboseMode Then _
		  System.DebugLog inMethodName + ": " + inMessage + " *-* (#" + Str( Integer( inError ) ) + ")." 
		  
		  RaiseEvent Error( inMessage, inError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPUBACK(inPUBACKData As MQTTLib.OptionsPUBACK)
		  //-- Process a PUBACK packet
		  
		  // Get the packet id
		  Dim thePacketID As UInt16 = inPUBACKData.PacketID
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName + ": Received a PUBACK with packetID #" + Str( thePacketID )
		  
		  // Check for zero packetID
		  If thePacketID = 0 Then
		    Self.ProcessProtocolError( CurrentMethodName, "A PUBACK's packetID can't be zero.", MQTTLib.Error.InvalidPacketID )
		    Return
		    
		  End If
		  
		  // Remove the original packet and timeout time from the unconfirmed control packet dictionaries
		  Self.RemovePacketAwaitingResponse( thePacketID )
		  
		  RaiseEvent ReceivedPUBACK( thePacketID )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPUBCOMP(inPUBCOMPData As MQTTLib.OptionsPUBCOMP)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPUBLISH(inPUBLISHData As MQTTLib.OptionsPUBLISH)
		  //-- Process a PUBLISH control packet
		  
		  If MQTTLib.VerboseMode Then
		    System.DebugLog CurrentMethodName + " PUBLISH received." + EndOfLine _
		    + "PacketID: " + Str( inPUBLISHData.PacketID ) _
		    + "Topic: " + inPUBLISHData.TopicName + EndOfLine _
		    + "Message: " + inPUBLISHData.Message
		    
		  End If
		  
		  If RaiseEvent ReceivedPUBLISH( inPUBLISHData ) Then Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPUBREC(inPUBRECData As MQTTLib.OptionsPUBREC)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPUBREL(inPUBRELData As MQTTLib.OptionsPUBREL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessSUBACK(inSUBACKData As MQTTLib.OptionsSUBACK)
		  //-- Process a PUBACK packet
		  
		  // Get the packet id
		  Dim thePacketID As UInt16 = inSUBACKData.PacketID
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName + ": Received a SUBACK with packetID #" + Str( thePacketID )
		  
		  // Check for zero packetID
		  If thePacketID = 0 Then
		    Self.ProcessProtocolError( CurrentMethodName, "A SUBACK's packetID can't be zero.", MQTTLib.Error.InvalidPacketID )
		    Return
		    
		  End If
		  
		  // Remove the original packet and timeout time from the unconfirmed control packet dictionaries
		  Self.RemovePacketAwaitingResponse(thePacketID)
		  
		  RaiseEvent ReceivedSUBACK( inSUBACKData )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Publish(inOptions As MQTTLib.OptionsPUBLISH)
		  //-- Send a PUBLISH control packet
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Pre conditions
		  If inOptions Is Nil Then _
		  Raise New zd.EasyNilObjectException( CurrentMethodName, "inOptions can't be nil." )
		  
		  // If there is no packetID assigned (ie = 0 ), then set a new one
		  If inOptions.PacketID = 0 Then inOptions.PacketID = Self.NewPacketID
		  
		  // Create and send the control packet
		  Dim thePacket As New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.PUBLISH, inOptions )
		  Self.SendControlPacket thePacket
		  
		  If inOptions.QoSLevel <> MQTTLib.QoS.AtMostOnceDelivery Then
		    // Store the packet for timeout purpose
		    Self.StorePacketAwaitingResponse( inOptions.PacketID, thePacket )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemovePacketAwaitingResponse(inPacketID As UInt16)
		  If Self.pPacketsAwaitingResponse.HasKey( inPacketID ) Then Self.pPacketsAwaitingResponse.Remove( inPacketID )
		  If Self.pPacketsAwaitingResponseTimeout.HasKey( inPacketID ) Then Self.pPacketsAwaitingResponseTimeout.Remove( inPacketID )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendControlPacket(inControlPacket As MQTTLib.ControlPacket)
		  //-- Send the control packet to the broker through the raw connection
		  
		  If Self.pConnected Or _
		    ( inControlPacket.Type = MQTTLib.ControlPacket.Type.CONNECT And Not ( Self.pRawConnection Is Nil ) ) Then
		    
		    // Send the control packet
		    Self.pRawConnection.SendControlPacket inControlPacket
		    
		    // Reset the keep alive timer
		    If Not( Self.pKeepAliveTimer Is Nil ) Then Self.pKeepAliveTimer.Reset
		    
		  Else // There is no connection
		    Dim theMessage As String = "There is no raw connection to send the packet."
		    System.DebugLog CurrentMethodName + ": " + theMessage
		    Self.ProcessProtocolError( CurrentMethodName, theMessage, MQTTLib.Error.NotConnected )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendPUBACK(inPacketID As UInt16)
		  //-- Send a PUBACK packet to the broker
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Check for zero packetID
		  If inPacketID <> 0 Then
		    // Build and send the PUBACK Control packet
		    Self.SendControlPacket New ControlPacket( MQTTLib.ControlPacket.Type.PUBACK, New MQTTLib.OptionsPUBACK( inPacketID ) ) 
		    
		  Else
		    Me.Disconnect
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, "A packetID can't be zero.", MQTTLib.Error.InvalidPacketID )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setup(inSocketAdapter As MQTTLib.SocketAdapter, inConnectionSetup As MQTTLib.OptionsCONNECT)
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Create the periodic check timer and wire it
		  Self.pPeriodicCheckTimer = New Timer
		  AddHandler Self.pPeriodicCheckTimer.Action, WeakAddressOf Self.HandlePeriodicCheck
		  
		  // Store the connection setup
		  Self.pConnectionSetup = inConnectionSetup
		  
		  // Create the raw connection
		  Self.pRawConnection = New MQTTLib.RawConnection( inSocketAdapter )
		  
		  // Wire its events
		  AddHandler Self.pRawConnection.Connected, WeakAddressOf Self.HandleRawConnectionConnected
		  AddHandler Self.pRawConnection.ControlPacketReceived, WeakAddressOf Self.HandleRawConnectionControlPacketReceived
		  AddHandler Self.pRawConnection.Error, WeakAddressOf Self.HandleRawConnectionError
		  
		  // Set the keep alive timer's period
		  Self.pKeepAliveTimer.Period = inConnectionSetup.KeepAlive * 1000
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StorePacketAwaitingResponse(inPacketID As UInt16, inControlPacket As MQTTLib.ControlPacket)
		  
		  Self.pPacketsAwaitingResponse.Value( inPacketID ) = inControlPacket
		  Self.pPacketsAwaitingResponseTimeout.Value( inPacketID ) = Microseconds + Self.pControlPacketTimeToLive * 1000000
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Subscribe(inOptions As MQTTLib.OptionsSUBSCRIBE)
		  // Subscribe to list of topics with a requested QoS
		  
		  If MQTTLib.VerboseMode Then System.DebugLog CurrentMethodName
		  
		  // Check the packet ID
		  If inOptions.PacketID = 0 Then inOptions.PacketID = Self.NewPacketID
		  
		  If MQTTLib.VerboseMode Then
		    Dim theParts() As String
		    theParts.Append CurrentMethodName + ": "
		    theParts.Append "PacketID: " + Str( inOptions.PacketID )
		    
		    Dim theCount As Integer = inOptions.Count
		    theParts.Append "TopicCount: " + Str( theCount )
		    
		    For i As Integer = 1 To theCount
		      Dim theTopic As MQTTLib.Topic = inOptions.Topic( i )
		      theParts.Append " * " + theTopic.Name + " (" + MQTTLib.QoSToString( theTopic.RequestedQoS ) + ")"
		      
		    Next
		    
		    System.DebugLog Join( theParts, EndOfLine )
		    
		  End If
		  
		  Dim thePacket As New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.PUBLISH, inOptions )
		  Self.SendControlPacket( thePacket )
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event BrokerConnected(inSessionPresentFlag As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BrokerConnectionRejected(inErrorCode As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(inMessage As String, inError As MQTTLib.Error)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceivedPINGRESP()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceivedPUBACK(inPacketID As UInt16)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceivedPUBLISH(inPublish As MQTTLib.OptionsPUBLISH) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceivedSUBACK(inSUBACKData As MQTTLib.OptionsSUBACK)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //-- Return True is the socket adapter is connected and the broker accepted the MQQT connection
			  
			  Return Self.pConnected
			End Get
		#tag EndGetter
		Connected As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pConnected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pConnectionSetup As MQTTLib.OptionsCONNECT
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pControlPacketTimeToLive As Integer = 10
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pKeepAliveTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Used by the 'NewPacketID()' method to keep a track of the generated IDs
		#tag EndNote
		Private pPacketIDCounter As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			This dictionary stores the latest packet sent. The key is the packetID.
		#tag EndNote
		Private pPacketsAwaitingResponse As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			This dictionary stores the timeout time of the latest packet sent. The key Is the packetID.
		#tag EndNote
		Private pPacketsAwaitingResponseTimeout As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pPeriodicCheckTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pRawConnection As MQTTLib.RawConnection
	#tag EndProperty


	#tag Constant, Name = kCONNECTDictionaryKey, Type = String, Dynamic = False, Default = \"CONNECT", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSentPingDictionaryKey, Type = String, Dynamic = False, Default = \"PINGREQ", Scope = Private
	#tag EndConstant


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
