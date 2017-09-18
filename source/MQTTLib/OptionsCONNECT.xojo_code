#tag Class
Protected Class OptionsCONNECT
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Function GetFixedHeaderFlagBits() As UInt8
		  Return &b0000
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawdata() As String
		  //-- Build the raw data from the properties.
		  
		  Dim theParts() As String
		  
		  // ---- Prepare the variable header ----
		  
		  theParts.Append MQTTLib.GetUInt16BinaryString( kProtocolName.LenB ) + kProtocolName.DefineEncoding( Nil )
		  theParts.Append ChrB( ProtocolLevel )
		  
		  theParts.Append ChrB( If( UsernameFlag, zd.Utils.Bits.kValueBit7, 0 ) _
		  + If( PasswordFlag, zd.Utils.Bits.kValueBit6, 0 ) _
		  + If( WillRetainFlag, zd.Utils.Bits.kValueBit5, 0 ) _
		  + ( WillQoS Mod zd.Utils.Bits.kValueBit2 ) * zd.Utils.Bits.kValueBit3 _
		  + If( WillFlag, zd.Utils.Bits.kValueBit2, 0 ) _
		  + If( CleanSessionFlag, zd.Utils.Bits.kValueBit1, 0 ) )
		  
		  theParts.Append MQTTLib.GetUInt16BinaryString( KeepAlive )
		  
		  // ---- Prepare the payload
		  
		  // The client ID
		  theParts.Append MQTTLib.GetMQTTRawString( ClientID )
		  
		  // The last will data
		  If WillFlag Then 
		    theParts.Append MQTTLib.GetMQTTRawString( WillTopic )
		    theParts.Append MQTTLib.GetMQTTRawString( WillMessage )
		    
		  End If
		  
		  // The login data
		  If UsernameFlag Then
		    theParts.Append MQTTLib.GetMQTTRawString( Username )
		    
		    // There can't be a password without a username
		    If PasswordFlag Then theParts.Append MQTTLib.GetMQTTRawString( Password )
		    
		  End If
		  
		  // Assemble the parts and return the result
		  Return Join( theParts, "" )
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseFixedHeaderFlagBits(inFlags As UInt8)
		  //-- Check if the flags are valid and raise an exception if they aren't.
		  
		  If inFlags <> &b0000 Then
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, Self.kInvalidFlagBitsMessage, MQTTLib.Error.InvalidFixedHeaderFlags )
		    
		  Else
		    Return
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseRawData(inRawData As MemoryBlock)
		  // Part of the MQTTLib.ControlPacketOptions interface
		  
		  #Pragma Warning "Not yet implemented"
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CleanSessionFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ClientID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		Password As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PasswordFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ProtocolLevel As UInt8 = 4
	#tag EndProperty

	#tag Property, Flags = &h0
		Username As String
	#tag EndProperty

	#tag Property, Flags = &h0
		UsernameFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		WillFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		WillMessage As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WillQoS As UInt8
	#tag EndProperty

	#tag Property, Flags = &h0
		WillRetainFlag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		WillTopic As String
	#tag EndProperty


	#tag Constant, Name = kInvalidFlagBitsMessage, Type = String, Dynamic = False, Default = \"The flag bits for CONNECT packet must be &b0000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kProtocolName, Type = String, Dynamic = False, Default = \"MQTT", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="CleanSessionFlag"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClientID"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Group="Behavior"
			Type="UInt16"
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
			Name="Password"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PasswordFlag"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolLevel"
			Group="Behavior"
			InitialValue="4"
			Type="UInt8"
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
			Name="Username"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UsernameFlag"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WillFlag"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WillMessage"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WillQoS"
			Group="Behavior"
			Type="UInt8"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WillRetainFlag"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WillTopic"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
