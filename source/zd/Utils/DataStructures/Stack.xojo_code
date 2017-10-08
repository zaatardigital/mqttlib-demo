#tag Class
Protected Class Stack
	#tag Method, Flags = &h0
		Sub ClearAll()
		  //-- Remove all the items in the stack
		  
		  #pragma DisableBackgroundTasks
		  
		  // Not the fastest but the simplest
		  Do Until IsEmpty
		    Call Pop
		    
		  Loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(inMaxSize As UInteger = 0)
		  pMaxSize = inMaxSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pop() As zd.Utils.DataStructures.PushableItem
		  
		  // Checking for error
		  If Me.pFirstItem Is Nil Then
		    Raise New zd.Utils.DataStructures.EmptyDataStructureException( CurrentMethodName, "You can't pop an empty stack." )
		    
		  End If
		  
		  Dim theResult As zd.Utils.DataStructures.PushableItem = pFirstItem
		  
		  pFirstItem = theResult.GetNextItem
		  
		  // Broke the link to avoid memory leaks
		  theResult.SetNextItem( Nil )
		  
		  // Adjust the size count and return the popped item
		  pSize = pSize - 1
		  Return theResult
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Push(inNewItem As zd.Utils.DataStructures.PushableItem)
		  // Checking for errors
		  If inNewItem Is Nil Then
		    Raise New zd.Utils.DataStructures.NilPushableItemException( CurrentMethodName, "Can't push a Nil item." )
		    
		  End If
		  
		  If pMaxSize > 0 And pSize = pMaxSize Then
		    Raise New zd.Utils.DataStructures.FullDataStructureException( CurrentMethodName, "This stack is full (max size is " + Str( Self.pMaxSize ) + ")." )
		    
		  End If
		  
		  // Push the new item on top of the stack
		  inNewItem.SetNextItem( pFirstItem )
		  pFirstItem = inNewItem
		  pSize = pSize + 1
		End Sub
	#tag EndMethod


	#tag Note, Name = Licensing
		MIT License
		
		Copyright (c) 2012-2017 Za'atar Digital
		
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
			  Return pFirstItem Is Nil
			End Get
		#tag EndGetter
		IsEmpty As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pMaxSize
			End Get
		#tag EndGetter
		MaxSize As UInteger
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pFirstItem As zd.Utils.DataStructures.PushableItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pMaxSize As UInteger
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pSize As UInteger
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return pSize
			End Get
		#tag EndGetter
		Size As UInteger
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
			Name="IsEmpty"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxSize"
			Group="Behavior"
			Type="UInteger"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Size"
			Group="Behavior"
			Type="UInteger"
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
