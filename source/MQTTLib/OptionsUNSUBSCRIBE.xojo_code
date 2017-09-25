#tag Class
Protected Class OptionsUNSUBSCRIBE
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Function GetFixedHeaderFlagBits() As UInt8
		  Return &b0010
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawData() As String
		  
		  Dim theParts() As String
		  
		  // --- The variable header ---
		  
		  theParts.Append MQTTLib.GetUInt16BinaryString( Self.PacketID )
		  
		  // --- The payload ---
		  
		  For Each Topic As String In pTopicNames
		    theParts.Append MQTTLib.GetMQTTRawString( Topic )
		    
		  Next
		  
		  // Return the joined parts
		  Return Join( theParts, "" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseFixedHeaderFlagBits(inFlags As UInt8)
		  //-- Check if the flags are valid and raise an exception if they aren't.
		  
		  If inFlags <> &b0010 Then
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, Self.kInvalidFlagBitsMessage, MQTTLib.Error.InvalidFixedHeaderFlags )
		    
		  Else
		    Return
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseRawData(inRawData As MemoryBlock)
		  
		  Dim theRawDataSize As Integer = inRawData.Size
		  Dim theReadCursor As Integer
		  
		  Do 
		    // Read the length of the topic
		    Dim theLength As Integer = inRawData.UInt16Value( theReadCursor )
		    theReadCursor = theReadCursor + 2
		    
		    // Read the topic string, sets its encoding and store it
		    pTopicNames.Append inRawData.StringValue( theReadCursor, theLength ).DefineEncoding( Encodings.UTF8 )
		    
		    // Update the cursor
		    theReadCursor = theReadCursor + theLength
		    
		  Loop Until theReadCursor >= theRawDataSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TopicName(inIndex As Integer) As String
		  //-- Return the inIndex-th topic (one based).
		  
		  Return Self.pTopicNames( inIndex - 1 )
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.pTopicNames.UBound + 1
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		PacketID As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pTopicNames() As String
	#tag EndProperty


	#tag Constant, Name = kInvalidFlagBitsMessage, Type = String, Dynamic = False, Default = \"The flag bits for UNSUBSCRIBEpacket must be &b0010", Scope = Public
	#tag EndConstant


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
