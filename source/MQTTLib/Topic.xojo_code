#tag Class
Protected Class Topic
	#tag Method, Flags = &h0
		Sub Constructor(inName As String, inRequestedQoS As MQTTLib.QoS)
		  pName = inName
		  pRequestedQoS = inRequestedQoS
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawData() As String
		  // Return the binary data representing this topic
		  Return MQTTLib.GetMQTTRawString( pName ) + ChrB( Integer( pRequestedQoS ) )
		End Function
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


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pName
			End Get
		#tag EndGetter
		Name As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pRequestedQoS As MQTTLib.Qos
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pRequestedQoS
			End Get
		#tag EndGetter
		RequestedQoS As MQTTLib.QoS
	#tag EndComputedProperty


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
			Name="RequestedQoS"
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
