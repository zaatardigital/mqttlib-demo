#tag Module
Protected Module MQTTLib
	#tag Method, Flags = &h21
		Private Function GetMQTTRawString(inString As String) As String
		  //-- Return a string with its length in a binary string
		  
		  Return GetUInt16BinaryString( InString.LenB ) + inString.DefineEncoding( Nil )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetUInt16BinaryString(inLength As UInt16) As String
		  Const kByteDivider = 256
		  Return ChrB( inLength \ kByteDivider ) + ChrB( inLength Mod 256 )
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SocketAdapterConnectedDelegate()
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SocketAdapterErrorDelegate(inError As MQTTLib.Error)
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SocketAdapterIncomingDataDelegate(inNewData As String)
	#tag EndDelegateDeclaration


	#tag Constant, Name = kDefaultPort, Type = Double, Dynamic = False, Default = \"1883", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kDefaultPortSecured, Type = Double, Dynamic = False, Default = \"8883", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = LibraryVersionString, Type = String, Dynamic = False, Default = \"zdMQTTLib v1.0a4", Scope = Protected
		#Tag Instance, Platform = Any, Language = Default, Definition  = \""
	#tag EndConstant

	#tag Constant, Name = MQTTVersionString, Type = String, Dynamic = False, Default = \"MQTT protocol v3.1.1", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = Error, Type = Integer, Flags = &h1
		NoError
		  Unknown
		  CantResolveAddress
		  InvalidPort
		  SelfDisconnection
		  TimedOut
		  LostConnection
		  SocketInvalidState
		  OutOfMemory
		  AddressInUse
		  MalformedFixedHeader
		  UnsupportedControlPacketType
		  ControlPacketNeedsData
		  ControlPacketDoesntNeedData
		  RemainingLengthExceedsMaximum
		  CONNACKParsingError
		  SUBACKParsingError
		SocketAdapterNotConnected
	#tag EndEnum

	#tag Enum, Name = QoS, Type = Integer, Flags = &h1
		AtMostOnceDelivery = 0
		  AtLeastOnceDelivery = 1
		ExactlyOnceDelivery = 2
	#tag EndEnum


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
End Module
#tag EndModule
