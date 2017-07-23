#tag Class
Protected Class OptionsPUBLISH
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Function GetRawdata() As String
		  // Build the raw data string
		  Dim theData() As String
		  
		  // The topic name preceded by its length
		  theData.Append MQTTLib.GetMQTTRawString( Self.TopicName )
		  
		  // The PacketID if needed
		  If Self.QoSLevel <> MQTTLib.QoS.AtLeastOnceDelivery Then theData.Append MQTTLib.GetUInt16BinaryString( Self.PacketID )
		  
		  // The message itself
		  theData.Append Self.Message
		  
		  Return Join( theData, "" )
		  
		  // Return MQTTLib.GetMQTTRawString( Self.TopicName ) _
		  // + If( Self.QoSLevel <> MQTTLib.QoS.AtLeastOnceDelivery, MQTTLib.GetUInt16BinaryString( Self.PacketID ), "" ) _
		  // + Message
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseRawData(inRawData As MemoryBlock)
		  //-- Parses the data
		  // Important: It relies on the QoSLevel being set prior to calling this method.
		  
		  Const kUInt16BytesSize = 2
		  
		  Dim theOffset As Integer
		  
		  // -- Read the Topic Name --
		  
		  // Get its length
		  Dim theTopicLength As UInt16 = inRawData.UInt16Value( theOffset )
		  theOffset = theOffset + kUInt16BytesSize
		  
		  Self.TopicName = inRawData.StringValue( theOffset, theTopicLength )
		  theOffset = theOffset + theTopicLength
		  
		  // -- Read the packet ID if there is one --
		  
		  If Self.QoSLevel <> MQTTLib.QoS.AtMostOnceDelivery Then
		    Self.PacketID = inRawData.UInt16Value( theOffset )
		    theOffset = theOffset + kUInt16BytesSize
		    
		  End If
		  
		  // -- Read the message --
		  
		  Dim theMessageLength As Integer = inRawData.Size - theOffset
		  Self.Message = inRawData.StringValue( theOffset, theMessageLength )
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		DUPFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Message As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PacketID As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		QoSLevel As MQTTLib.QoS
	#tag EndProperty

	#tag Property, Flags = &h0
		RETAINFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		TopicName As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="DUPFlag"
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PacketID"
			Group="Behavior"
			Type="UInt16"
		#tag EndViewProperty
		#tag ViewProperty
			Name="QoSLevel"
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
			Name="RETAINFlag"
			Group="Behavior"
			Type="Boolean"
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
		#tag ViewProperty
			Name="TopicName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
