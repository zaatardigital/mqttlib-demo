#tag Class
Protected Class ClientConnection
	#tag Method, Flags = &h0
		Sub Constructor(inSocketAdapter As MQTTLib.SocketAdapter, inConnectionSetup As MQTTLib.OptionsCONNECT)
		  
		  // Store the connection setup
		  Self.pConnectionSetup = inConnectionSetup
		  
		  // Create the raw connection
		  Self.pRawConnection = New MQTTLib.RawConnection( inSocketAdapter )
		  
		  // Wire its events
		  AddHandler Self.pRawConnection.Connected, AddressOf Self.HandleRawConnectionConnected
		  AddHandler Self.pRawConnection.ControlPacketReceived, AddressOf Self.HandleRawConnectionControlPacketReceived
		  AddHandler Self.pRawConnection.Error, AddressOf Self.HandleRawConnectionError
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionConnected(inRawConnection As MQTTLib.RawConnection)
		  //-- The socket adapter is connected, let's open the MQTT connection
		  
		  // Create the CONNECT control packet with the options passed to the constructor
		  Dim theCONNECTPacket As New MQTTLib.ControlPacket( MQTTLib.ControlPacket.Type.CONNECT, Self.pConnectionSetup )
		  
		  // Send the packet
		  Self.SendControlPacket theCONNECTPacket
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionControlPacketReceived(inRawConnection As MQTTLib.RawConnection, inControlPacket As MQTTLib.ControlPacket)
		  //-- A new control packet is available
		  
		  Select Case inControlPacket.Type
		    
		  Case MQTTLib.ControlPacket.Type.CONNACK
		    Self.ProcessCONNACK( MQTTLib.OptionsCONNACK( inControlPacket.Options ) )
		    
		  Else
		    Break
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleRawConnectionError(inRawConnection As MQTTLib.RawConnection, inError As MQTTLib.Error)
		  //-- Handles an error from the raw connection
		  
		  RaiseEvent Error( inError )
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
		    RaiseEvent BrokerConnected( inOptions.SessionPresentFlag )
		    
		  Else
		    // The connection has been refused by the broker
		    RaiseEvent BrokerConnectionRejected( iNOptions.ReturnCode )
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendControlPacket(inControlPacket As MQTTLib.ControlPacket)
		  //-- Send the control packet to the broker through the raw connection
		   
		  Self.pRawConnection.SendControlPacket inControlPacket
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
		Private pRawConnection As MQTTLib.RawConnection
	#tag EndProperty


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
			Name="pConnectionSetup"
			Group="Behavior"
			Type="Integer"
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
