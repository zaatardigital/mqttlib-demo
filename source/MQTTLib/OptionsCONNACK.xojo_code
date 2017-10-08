#tag Class
Protected Class OptionsCONNACK
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Function GetFixedHeaderFlagBits() As UInt8
		  Return &b0000
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawData() As String
		  
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
		  
		  If inRawData.Size <> 2 Then
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, _
		    "inRawData size was " + Str( inRawData.Size ) + " but should be 2.", _
		    MQTTLib.Error.CONNACKParsingError )
		    
		  End If
		  
		  SessionPresentFlag = ( inRawData.Byte( 0 ) And zd.Utils.Bits.kValueBit0 ) > 0
		  ReturnCode = inRawData.Byte( 1 )
		End Sub
	#tag EndMethod


	#tag Note, Name = Licensing
		MIT License
		
		Copyright (c) 2017 Za'atar Digital
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	#tag EndNote


	#tag Property, Flags = &h0
		ReturnCode As UInt8
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionPresentFlag As Boolean
	#tag EndProperty


	#tag Constant, Name = kInvalidFlagBitsMessage, Type = String, Dynamic = False, Default = \"The flag bits for CONNACK packet must be &b0000", Scope = Public
	#tag EndConstant

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
