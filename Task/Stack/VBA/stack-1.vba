'Simple Stack class

'uses a dynamic array of Variants to stack the values
'has read-only property "Size"
'and methods "Push", "Pop", "IsEmpty"

Private myStack()
Private myStackHeight As Integer

'method Push
Public Function Push(aValue)
  'increase stack height
  myStackHeight = myStackHeight + 1
  ReDim Preserve myStack(myStackHeight)
  myStack(myStackHeight) = aValue
End Function

'method Pop
Public Function Pop()
  'check for nonempty stack
  If myStackHeight > 0 Then
    Pop = myStack(myStackHeight)
    myStackHeight = myStackHeight - 1
  Else
    MsgBox "Pop: stack is empty!"
  End If
End Function

'method IsEmpty
Public Function IsEmpty() As Boolean
  IsEmpty = (myStackHeight = 0)
End Function

'property Size
Property Get Size() As Integer
  Size = myStackHeight
End Property
