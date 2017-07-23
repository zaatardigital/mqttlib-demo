#tag Class
Protected Class OptionsCONNACK
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Function GetRawData() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseRawData(inRawData As MemoryBlock)
		  
		  If inRawData.Size <> 2 Then
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, _
		    "inRawData size was " + Str( inRawData.Size ) + " but should be 2.", _
		    MQTTLib.Error.CONNACKParsingError )
		    
		  End If
		  
		  SessionPresentFlag = ( inRawData.Byte( 0 ) And zd.Utils.Bits.kValueBit0 ) > 0
		  ReturnCode = inRawData.Byte( 1 )
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ReturnCode As UInt8
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionPresentFlag As Boolean
	#tag EndProperty


	#tag Constant, Name = kReturnCodeBadUsernameOrPassword, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kReturnCodeClientIdentifierRejected, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kReturnCodeConnectionAccepted, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kReturnCodeNotAuthorized, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kReturnCodeServerUnavailable, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kReturnCodeUnacceptableProtocolVersion, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant


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
			Name="ReturnCode"
			Group="Behavior"
			Type="UInt8"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionPresentFlag"
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
	#tag EndViewBehavior
End Class
#tag EndClass
