#tag Class
Protected Class OptionsPUBREL
Inherits MQTTLib.OptionsPUBCommons
	#tag Method, Flags = &h0
		Sub ParseFixedHeaderFlagBits(inFlags As UInt8)
		  //-- Check if the flags are valid and raise an exception if they aren't.
		  
		  If inFlags <> &b0010 Then
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, Self.kInvalidPUBRELFlagBitsMessage, MQTTLib.Error.InvalidFixedHeaderFlags )
		    
		  Else
		    Return
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Constant, Name = kInvalidPUBRELFlagBitsMessage, Type = String, Dynamic = False, Default = \"The flag bits for PUBREL packet must be &b0010", Scope = Public
	#tag EndConstant


End Class
#tag EndClass
