' Queue Definition - VBScript
Option Explicit
Dim queue, i, x
Set queue = CreateObject("System.Collections.ArrayList")
If Not empty_(queue) Then Wscript.Echo queue.Count
push queue, "Banana"
push queue, "Apple"
push queue, "Pear"
push queue, "Strawberry"
Wscript.Echo "Count=" & queue.Count
Wscript.Echo pull(queue) & " - Count=" & queue.Count '
Wscript.Echo "Head=" & queue.Item(0)
Wscript.Echo "Tail=" & queue.Item(queue.Count-1)
Wscript.Echo queue.IndexOf("Pear", 0)
For i=1 To queue.Count
	Wscript.Echo join(queue.ToArray(), ", ")
	x = pull(queue)
Next 'i

Sub push(q, what)
    q.Add what
End Sub 'push

Function pull(q)
	Dim what
    If q.Count > 0 Then
        what = q(0)
        q.RemoveAt 0
    Else
        what = ""
    End If
    pull = what
End Function 'pull

Function empty_(q)
    empty_ = q.Count = 0
End Function 'empty_
