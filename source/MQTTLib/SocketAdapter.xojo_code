#tag Interface
Protected Interface SocketAdapter
	#tag Method, Flags = &h0
		Sub Connect()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disconnect()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RegisterDelegates(inConnectedDelegate AS MQTTLib.SocketAdapterConnectedDelegate, inDataDelegate AS MQTTLib.SocketAdapterIncomingDataDelegate, inErrorDelegate AS MQTTLib.SocketAdapterErrorDelegate)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveDelegates()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendControlPacket(inControlPacket As MQTTLib.ControlPacket)
		  
		End Sub
	#tag EndMethod


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
End Interface
#tag EndInterface
