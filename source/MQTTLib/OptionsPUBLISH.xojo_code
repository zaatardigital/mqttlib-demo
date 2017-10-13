#tag Class
Protected Class OptionsPUBLISH
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Function GetFixedHeaderFlagBits() As UInt8
		  Return If( Self.RETAINFlag, zd.Utils.Bits.kValueBit0, 0 ) _
		  + Integer( Self.QoSLevel ) * zd.Utils.Bits.kValueBit1 _
		  + If( Self.DUPFlag, zd.Utils.Bits.kValueBit3, 0 ) 
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawdata() As String
		  // Build the raw data string
		  Dim theData() As String
		  
		  // The topic name preceded by its length
		  theData.Append MQTTLib.GetMQTTRawString( Self.TopicName )
		  
		  // The PacketID if needed as a UInt16
		  If Self.QoSLevel <> MQTTLib.QoS.AtMostOnceDelivery Then
		    theData.Append MQTTLib.GetUInt16BinaryString( Self.PacketID )
		    
		  End If
		  
		  // The message itself
		  theData.Append Self.Message
		  
		  Return Join( theData, "" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseFixedHeaderFlagBits(inFlags As UInt8)
		  //-- Check if the flags are valid and raise an exception if they aren't.
		  
		  // Set the flags... and the QoS
		  Self.RETAINFlag = ( inFlags And zd.Utils.Bits.kValueBit0 ) > 0
		  Self.DUPFlag = ( inFlags And zd.Utils.Bits.kValueBit3 ) > 0
		  
		  // Extract and shift the QoS bits
		  Dim theQoS As UInt8 _
		  = If( ( inFlags And zd.Utils.Bits.kValueBit1 ) > 0, zd.Utils.Bits.kValueBit0, 0 ) _
		  + If( ( inFlags And zd.Utils.Bits.kValueBit2 ) > 0, zd.Utils.Bits.kValueBit1, 0 )
		  
		  Select Case theQoS
		    
		  Case Integer( MQTTLib.QoS.AtMostOnceDelivery ) // QoS = 0
		    Self.QoSLevel = MQTTLib.QoS.AtMostOnceDelivery
		    
		    // DUP flag must be false for this QoS
		    If Self.DUPFlag Then
		      Raise New MQTTLib.ProtocolException( CurrentMethodName, Self.kInvalidDUPFlagErrorMessage, MQTTLib.Error.InvalidFixedHeaderFlags )
		      
		    End If
		    
		  Case Integer( MQTTLib.QoS.AtLeastOnceDelivery ) // QoS = 1
		    Self.QoSLevel = MQTTLib.QoS.AtLeastOnceDelivery
		    
		  Case Integer( MQTTLib.QoS.ExactlyOnceDelivery )
		    Self.QoSLevel = MQTTLib.QoS.ExactlyOnceDelivery // QoS = 2
		    
		  Else // QoS = 3 -> Invalid
		    Raise New MQTTLib.ProtocolException( CurrentMethodName, Self.kInvalidQoSValueMessage, MQTTLib.Error.InvalidFixedHeaderFlags )
		    
		  End Select
		End Sub
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
		  
		  Self.TopicName = DefineEncoding( inRawData.StringValue( theOffset, theTopicLength ), Encodings.UTF8 )
		  theOffset = theOffset + theTopicLength
		  
		  // -- Read the packet ID if there is one --
		  
		  If Self.QoSLevel <> MQTTLib.QoS.AtMostOnceDelivery Then
		    Self.PacketID = inRawData.UInt16Value( theOffset )
		    theOffset = theOffset + kUInt16BytesSize
		    
		  End If
		  
		  // -- Read the message --
		  
		  Dim theMessageLength As Integer = inRawData.Size - theOffset
		  Self.Message = DefineEncoding( inRawData.StringValue( theOffset, theMessageLength ), Encodings.UTF8 )
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


	#tag Constant, Name = kInvalidDUPFlagErrorMessage, Type = String, Dynamic = False, Default = \"The DUP Flag MUST not be set when QoS \x3D 0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kInvalidQoSValueMessage, Type = String, Dynamic = False, Default = \"Invalid QoS value.", Scope = Public
	#tag EndConstant


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
