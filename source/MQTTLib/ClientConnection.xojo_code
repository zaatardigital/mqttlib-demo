#tag Class
Protected Class ClientConnection
	#tag Method, Flags = &h21
		Private Sub HandleKeepAliveTimerAction(inTimer As Timer)
		  #pragma Unused inTimer
		  
		  // Give Me a ping, Vassily. One ping only, please.
		  Self.SendControlPacket( New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.PINGREQ ) )
		  
		  // Store the time is was sent
		  Self.pSentControlPackets.Value( kSentPingDictionaryKey ) = Microseconds
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandlePeriodicCheck(inTimer As Timer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionConnected(inRawConnection As MQTTLib.RawConnection)
		  //-- The socket adapter is connected, let's open the MQTT connection
		  
		  // Create the CONNECT control packet with the options passed to the constructor
		  Dim theCONNECTPacket As New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.CONNECT, Self.pConnectionSetup )
		  
		  // Send the packet
		  Self.SendControlPacket theCONNECTPacket
		  
		  // Store the time it was sent
		  Self.pSentControlPackets.Value( kCONNECTDictionaryKey ) = Microseconds
		  
		  // Start the periodic checker timer
		  Self.pPeriodicCheckTimer.Mode = Timer.ModeMultiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionControlPacketReceived(inRawConnection As MQTTLib.RawConnection, inControlPacket As MQTTLib.ControlPacket)
		  //-- A new control packet is available
		  
		  Select Case inControlPacket.Type
		    
		  Case MQTTLib.ControlPacket.Type.CONNACK
		    Self.ProcessCONNACK( MQTTLib.OptionsCONNACK( inControlPacket.Options ) )
		    
		  Case MQTTLib.ControlPacket.Type.PINGRESP
		    // Remove the PING from the sent packet dictionary
		    If Self.pSentControlPackets.HasKey( kSentPingDictionaryKey ) Then Self.pSentControlPackets.Remove( kSentPingDictionaryKey )
		    
		  Else
		    Break
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionError(inRawConnection As MQTTLib.RawConnection, inError As MQTTLib.Error)
		  //-- Handles an error from the raw connection
		  
		  // We are no longer connected
		  Self.pConnected = False
		  
		  // Deactivate the keep alive timer
		  Self.pKeepAliveTimer.Mode = Timer.ModeOff
		  
		  // Signal the error to the subclass
		  RaiseEvent Error( inError )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleResponseTimeOut()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Open()
		  //-- Initiates the connection process by opening the raw connection
		  // Next step will occured in the HandleRawConnectionConnected() method
		  
		  Self.pRawConnection.Open
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessCONNACK(inOptions As MQTTLib.OptionsCONNACK)
		  //-- Process the received CONNACK control packet
		  
		  // Is the connection accepted?
		  If inOptions.ReturnCode = MQTTLib.OptionsCONNACK.kReturnCodeConnectionAccepted Then
		    // We are connected to the MQTT broker
		    pConnected = True
		    
		    // Starting the keep alive timer
		    Self.pKeepAliveTimer.Mode = Timer.ModeMultiple
		    
		    RaiseEvent BrokerConnected( inOptions.SessionPresentFlag )
		    
		  Else
		    // The connection has been refused by the broker
		    RaiseEvent BrokerConnectionRejected( iNOptions.ReturnCode )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Publish(inOptions As MQTTLib.OptionsPUBLISH)
		  // Pre conditions
		  If inOptions Is Nil Then _
		  Raise New zd.EasyNilObjectException( CurrentMethodName, "inOptions can't be nil." )
		  
		  // Create and send the control packet
		  Dim thePacket As New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.PUBLISH, inOptions )
		  Self.SendControlPacket thePacket
		  
		  // Store the packet for timeout purpose
		  If inOptions.QoSLevel <> MQTTLib.QoS.AtMostOnceDelivery Then _
		  Self.pSentControlPackets.Value( inOptions.PacketID ) = Xojo.Core.Date.Now.SecondsFrom1970 + Self.pControlPacketTimeToLive : thePacket
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendControlPacket(inControlPacket As MQTTLib.ControlPacket)
		  //-- Send the control packet to the broker through the raw connection
		  
		  // Send the control packet
		  Self.pRawConnection.SendControlPacket inControlPacket
		  
		  // Reset the keep alive timer
		  Self.pKeepAliveTimer.Reset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setup(inSocketAdapter As MQTTLib.SocketAdapter, inConnectionSetup As MQTTLib.OptionsCONNECT)
		  
		  // Create the sent packet dictionary
		  Self.pSentControlPackets = New Xojo.Core.Dictionary
		  
		  // and its periodic check timer
		  Self.pPeriodicCheckTimer = New Timer
		  AddHandler Self.pPeriodicCheckTimer.Action, AddressOf Self.HandlePeriodicCheck
		  
		  // Store the connection setup
		  Self.pConnectionSetup = inConnectionSetup
		  
		  // Create the raw connection
		  Self.pRawConnection = New MQTTLib.RawConnection( inSocketAdapter )
		  
		  // Wire its events
		  AddHandler Self.pRawConnection.Connected, AddressOf Self.HandleRawConnectionConnected
		  AddHandler Self.pRawConnection.ControlPacketReceived, AddressOf Self.HandleRawConnectionControlPacketReceived
		  AddHandler Self.pRawConnection.Error, AddressOf Self.HandleRawConnectionError
		  
		  // Create the keep alive timer
		  Self.pKeepAliveTimer = New Timer
		  Self.pKeepAliveTimer.Period = inConnectionSetup.KeepAlive * 1000
		  
		  // and wire it
		  AddHandler Self.pKeepAliveTimer.Action, AddressOf Self.HandleKeepAliveTimerAction
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event BrokerConnected(inSessionPresentFlag As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BrokerConnectionRejected(inErrorCode As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(inError As MQTTLib.Error)
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
		Private pPeriodicCheckTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pRawConnection As MQTTLib.RawConnection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pSentControlPackets As Xojo.Core.Dictionary
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
