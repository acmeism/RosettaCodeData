Private Function sum(i As String, ByVal lo As Integer, ByVal hi As Integer, term As String) As Double
    Dim temp As Double
    For k = lo To hi
        temp = temp + Evaluate(Replace(term, i, k))
    Next k
    sum = temp
End Function
Sub Jensen_Device()
    Debug.Print sum("i", 1, 100, "1/i")
    Debug.Print sum("i", 1, 100, "i*i")
    Debug.Print sum("j", 1, 100, "sin(j)")
End Sub
