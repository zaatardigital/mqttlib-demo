#tag Class
Protected Class OptionsPUBXXX
Implements ControlPacketOptions
	#tag Method, Flags = &h0
		Sub Constructor(inPacketID As UInt16 = 0)
		  Self.pPacketID = inPacketID
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRawdata() As String
		  Return MQTTLib.GetUInt16BinaryString( Self.pPacketID )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseRawData(inRawData As MemoryBlock)
		  Self.pPacketID = inRawData.UInt16Value( 0 )
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.pPacketID
			End Get
		#tag EndGetter
		PacketID As UInt16
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pPacketID As UInt16
	#tag EndProperty


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
