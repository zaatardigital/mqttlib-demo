#tag Class
Protected Class ProtocolException
Inherits zd.EasyException
	#tag Method, Flags = &h21
		Private Sub Constructor(inMethodName As String, inMessage As String, inErrorCode As Integer = -1)
		  // Just for deactivation of this constructor signature
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(inMethodName As String, inMessage As String, inError As MQTTLib.Error)
		  // Calling the overridden superclass constructor.
		  Super.Constructor( inMethodName, inMessage )
		  
		  Self.pProtocolException = inError
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


	#tag Property, Flags = &h21
		Private pProtocolException As MQTTLib.Error
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.pProtocolException
			End Get
		#tag EndGetter
		ProtocolError As MQTTLib.Error
	#tag EndComputedProperty


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
			Name="ProtocolError"
			Group="Behavior"
			Type="MQTTLib.Error"
			EditorType="Enum"
			#tag EnumValues
				"0 - NoError"
				"1 - Unknown"
				"2 - CantResolveAddress"
				"3 - InvalidPort"
				"4 - SelfDisconnection"
				"5 - TimedOut"
				"6 - LostConnection"
				"7 - SocketInvalidState"
				"8 - OutOfMemory"
				"9 - AddressInUse"
				"10 - MalformedFixedHeader"
				"11 - UnsupportedControlPacketType"
				"12 - ControlPacketNeedsData"
				"13 - ControlPacketDoesntNeedData"
				"14 - RemainingLengthExceedsMaximum"
				"15 - CONNACKParsingError"
				"16 - SUBACKParsingError"
				"17 - SocketAdapterNotConnected"
				"18 - InvalidFixedHeaderFlags"
				"19 - InvalidPacketID"
				"20 - PINGTimedOut"
				"21 - NotConnected"
				"22 - UnknownPacketID"
				"23 - UnexpectedResponseType"
			#tag EndEnumValues
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
