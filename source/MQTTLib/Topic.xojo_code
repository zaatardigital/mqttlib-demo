#tag Class
Protected Class Topic
	#tag Method, Flags = &h0
		Sub Constructor(inName As String, inRequestedQoS As MQTTLib.QoS)
		  pName = inName
		  pRequestedQoS = inRequestedQoS
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawData() As String
		  // Return the binary data representing this topic
		  Return MQTTLib.GetMQTTRawString( pName ) + ChrB( Integer( pRequestedQoS ) )
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pName
			End Get
		#tag EndGetter
		Name As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pRequestedQoS As MQTTLib.Qos
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pRequestedQoS
			End Get
		#tag EndGetter
		RequestedQoS As MQTTLib.QoS
	#tag EndComputedProperty


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
			Name="RequestedQoS"
			Group="Behavior"
			Type="MQTTLib.QoS"
			EditorType="Enum"
			#tag EnumValues
				"0 - AtMostOnceDelivery"
				"1 - AtLeastOnceDelivery"
				"2 - ExactlyOnceDelivery"
			#tag EndEnumValues
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
