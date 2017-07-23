#tag Class
Protected Class EasyException
Inherits RuntimeException
	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)), Description = 436F6E7374727563746F7220666F72204465736B746F702C2057656220616E6420436F6E736F6C652E
		Sub Constructor(inMethodName As String, inMessage As String, inErrorCode As Integer = -1)
		  
		  // Set the data
		  Self.ErrorNumber = inErrorCode
		  Self.Message = "[" + inMethodName + "] -> " + inMessage
		  
		  If zd.EasyException.LogMode = zd.EasyException.LogModes.Always _
		    Or ( DebugBuild And zd.EasyException.LogMode = zd.EasyException.LogModes.DebugBuildOnly ) Then
		    
		    // Log the information
		    System.DebugLog Introspection.GetType( Self ).FullName + " raised with error #(" + Str( Self.ErrorNumber ) + ")" + EndOfLine + " -- " + Self.Message
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Shared LogMode As zd.EasyException.LogModes = zd.EasyException.LogModes.DebugBuildOnly
	#tag EndProperty


	#tag Enum, Name = LogModes, Type = Integer, Flags = &h0
		None
		  DebugBuildOnly
		Always
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
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
			Name="Reason"
			Group="Behavior"
			Type="Text"
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
