#tag Module
Protected Module MQTTLib
	#tag Method, Flags = &h0
		Function ErrorToString(inError As MQTTLib.Error) As String
		  Select Case inError
		    
		  Case MQTTLib.Error.AddressInUse
		    Return "MQTTLib.Error.AddressInUse"
		    
		  Case MQTTLib.Error.CantResolveAddress
		    Return "MQTTLib.Error.CantResolveAddress"
		    
		  Case MQTTLib.Error.CONNACKParsingError
		    Return "MQTTLib.Error.CONNACKParsingError"
		    
		  Case MQTTLib.Error.ControlPacketDoesntNeedData
		    Return "MQTTLib.Error.ControlPacketDoesntNeedData"
		    
		  Case MQTTLib.Error.ControlPacketNeedsData
		    Return "MQTTLib.Error.ControlPacketNeedsData"
		    
		  Case MQTTLib.Error.InvalidFixedHeaderFlags
		    Return "MQTTLib.Error.InvalidFixedHeaderFlags"
		    
		  Case MQTTLib.Error.InvalidPacketID
		    Return "MQTTLib.Error.NoError"
		    
		  Case MQTTLib.Error.InvalidPort
		    Return "MQTTLib.Error.InvalidPort"
		    
		  Case MQTTLib.Error.LostConnection
		    Return "MQTTLib.Error.LostConnection"
		    
		  Case MQTTLib.Error.MalformedFixedHeader
		    Return "MQTTLib.Error.MalformedFixedHeader"
		    
		  Case MQTTLib.Error.NoError
		    Return "MQTTLib.Error.NoError"
		    
		  Case MQTTLib.Error.OutOfMemory
		    Return "MQTTLib.Error.OutOfMemory"
		    
		  Case MQTTLib.Error.RemainingLengthExceedsMaximum
		    Return "MQTTLib.Error.RemainingLengthExceedsMaximum"
		    
		  Case MQTTLib.Error.SelfDisconnection
		    Return "MQTTLib.Error.SelfDisconnection"
		    
		  Case MQTTLib.Error.SocketAdapterNotConnected
		    Return "MQTTLib.Error.SocketAdapterNotConnected"
		    
		  Case MQTTLib.Error.SocketInvalidState
		    Return "MQTTLib.Error.SocketInvalidState"
		    
		  Case MQTTLib.Error.SUBACKParsingError
		    Return "MQTTLib.Error.SUBACKParsingError"
		    
		  Case MQTTLib.Error.TimedOut
		    Return "MQTTLib.Error.TimedOut"
		    
		  Case MQTTLib.Error.Unknown
		    Return "MQTTLib.Error.Unknown"
		    
		  Case MQTTLib.Error.UnsupportedControlPacketType
		    Return "MQTTLib.Error.UnsupportedControlPacketType"
		    
		  Case MQTTLib.Error.PINGTimedout
		    Return "MQTTLib.Error.PINGTimedOut"
		    
		  Case MQTTLib.Error.NotConnected
		    Return "MQTTLib.Error.NotConnected"
		    
		  Else
		    Raise New zd.EasyException( CurrentMethodName, "Unimplemented case #" + Str( Integer ( inError ) ) + " for MQTTLib.Error enumeration." )
		    
		  End Select
		End Function
	#tag EndMethod

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

	#tag Method, Flags = &h0
		Function QoSToString(inQoS As MQTTLib.QoS) As String
		  
		  Select Case inQoS
		  Case MQTTLib.QoS.AtMostOnceDelivery
		    Return "MQTTLib.QoS.AtMostOnceDelivery"
		    
		  Case MQTTLib.QoS.AtLeastOnceDelivery
		    Return "MQTTLib.QoS.AtLeastOnceDelivery"
		    
		  Case MQTTLib.QoS.ExactlyOnceDelivery
		    Return "MQTTLib.QoS.ExactlyOnceDelivery"
		    
		  Else
		    Raise New zd.EasyException( CurrentMethodName, "Unimplemented case #" + Str( Integer ( inQoS ) ) + " for MQTTLib.QoS enumeration." )
		    
		  End Select
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SocketAdapterConnectedDelegate()
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SocketAdapterErrorDelegate(inError As MQTTLib . Error)
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SocketAdapterIncomingDataDelegate(inNewData As String)
	#tag EndDelegateDeclaration


	#tag Property, Flags = &h1
		Protected VerboseMode As Boolean
	#tag EndProperty


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
		  InvalidFixedHeaderFlags
		  InvalidPacketID
		  PINGTimedOut
		NotConnected
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
