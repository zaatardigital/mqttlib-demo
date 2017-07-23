#tag Class
Protected Class OptionsSUBSCRIBE
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Sub AddTopic(inTopic As String, inRequestedQoS As MQTTLib.QoS)
		  Self.pTopics.Append New MQTTLib.Topic( inTopic, inRequestedQoS )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawData() As String
		  
		  Dim theParts() As String
		  
		  // --- The variable header ---
		  
		  theParts.Append MQTTLib.GetUInt16BinaryString( Self.PacketID )
		  
		  // --- The payload ---
		  
		  For Each Topic As MQTTLib.Topic In pTopics
		    theParts.Append Topic.GetRawData
		    
		  Next
		  
		  // Return the joined parts
		  Return Join( theParts, "" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseRawData(inRawData As MemoryBlock)
		  
		  Dim theRawDataSize As Integer = inRawData.Size
		  Dim theReadCursor As Integer
		  
		  Do 
		    // Read the length of the topic
		    Dim theLength As Integer = inRawData.UInt16Value( theReadCursor )
		    theReadCursor = theReadCursor + 2
		    
		    // Read the topic string
		    Dim theTopic As String = inRawData.StringValue( theReadCursor, theLength ).DefineEncoding( Encodings.UTF8 )
		    theReadCursor = theReadCursor + theLength
		    
		    // Read and convert the requested QoS for this topic
		    Dim theQoS As MQTTLib.QoS
		    Select Case inRawData.UInt8Value( theReadCursor )
		      
		    Case Integer( MQTTLib.QoS.AtLeastOnceDelivery )
		      theQoS = MQTTLib.QoS.AtLeastOnceDelivery
		      
		    Case Integer( MQTTLib.QoS.AtMostOnceDelivery )
		      theQoS = MQTTLib.QoS.AtMostOnceDelivery
		      
		    Case Integer( MQTTLib.QoS.ExactlyOnceDelivery )
		      theQoS = MQTTLib.QoS.ExactlyOnceDelivery
		      
		    End Select
		    
		    theReadCursor = theReadCursor + 1
		    
		    // Append this entry
		    pTopics.Append New MQTTLib.Topic( theTopic, theQoS )
		    
		  Loop Until theReadCursor = theRawDataSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Topic(inIndex As Integer) As MQTTLib.Topic
		  //-- Returns the inIndex-th topic
		  
		  Return Self.pTopics( inIndex - 1 ) 
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //-- Return the number of topic.
			  
			  Return Self.pTopics.UBound + 1
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		PacketID As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pTopics() As MQTTLib.Topic
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			Type="Integer"
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
			Name="PacketID"
			Group="Behavior"
			Type="UInt16"
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
