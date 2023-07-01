' Stack Definition - VBScript

Option Explicit

Dim stack, i, x
Set stack = CreateObject("System.Collections.ArrayList")
If Not empty_(stack) Then Wscript.Echo stack.Count
push stack, "Banana"
push stack, "Apple"
push stack, "Pear"
push stack, "Strawberry"
Wscript.Echo "Count=" & stack.Count 		    ' --> Count=4
Wscript.Echo pop(stack) & " - Count=" & stack.Count ' --> Strawberry - Count=3
Wscript.Echo "Tail=" & stack.Item(0) 		    ' --> Tail=Banana
Wscript.Echo "Head=" & stack.Item(stack.Count-1)    ' --> Head=Pear
Wscript.Echo stack.IndexOf("Apple", 0)   	    ' --> 1
For i=1 To stack.Count
	Wscript.Echo join(stack.ToArray(), ", ")
	x = pop(stack)
Next 'i

Sub push(s, what)
    s.Add what
End Sub 'push

Function pop(s)
	Dim what
    If s.Count > 0 Then
        what = s(s.Count-1)
        s.RemoveAt s.Count-1
    Else
        what = ""
    End If
    pop = what
End Function 'pop

Function empty_(s)
    empty_ = s.Count = 0
End Function 'empty_
