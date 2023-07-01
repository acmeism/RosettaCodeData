Sub CountOctal()
Dim i As Integer
i = 0
On Error GoTo OctEnd
Do
    Debug.Print Oct(i)
    i = i + 1
Loop
OctEnd:
Debug.Print "Integer overflow - count terminated"
End Sub
