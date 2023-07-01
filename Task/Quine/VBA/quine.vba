Public Sub quine()
    quote = Chr(34)
    comma = Chr(44)
    cont = Chr(32) & Chr(95)
    n = Array( _
"Public Sub quine()", _
"    quote = Chr(34)", _
"    comma = Chr(44)", _
"    cont = Chr(32) & Chr(95)", _
"    n = Array( _", _
"    For i = 0 To 4", _
"        Debug.Print n(i)", _
"    Next i", _
"    For i = 0 To 15", _
"        Debug.Print quote & n(i) & quote & comma & cont", _
"    Next i", _
"    Debug.Print quote & n(15) & quote & Chr(41)", _
"    For i = 5 To 15", _
"        Debug.Print n(i)", _
"    Next i", _
"End Sub")
    For i = 0 To 4
        Debug.Print n(i)
    Next i
    For i = 0 To 14
        Debug.Print quote & n(i) & quote & comma & cont
    Next i
    Debug.Print quote & n(15) & quote & Chr(41)
    For i = 5 To 15
        Debug.Print n(i)
    Next i
End Sub
