Public Sub narcissist()
    quote = Chr(34)
    comma = Chr(44)
    cont = Chr(32) & Chr(95)
    rparen = Chr(41)
    n = Array( _
"Public Sub narcissist()", _
"    quote = Chr(34)", _
"    comma = Chr(44)", _
"    cont = Chr(32) & Chr(95)", _
"    rparen = Chr(41)", _
"    n = Array( _", _
"How many lines?", _
"Line ", _
"    x = InputBox(n(5))", _
"    flag = True", _
"    For i = 0 To 5", _
"        If InputBox(n(6) & i) <> n(i) Then flag = False", _
"    Next i", _
"    For i = 0 To 20", _
"        If InputBox(n(6) & i + 6) <> quote & n(i) & quote & comma & cont Then flag = False", _
"    Next i", _
"    If InputBox(n(6) & 27) <> quote & n(21) & quote & rparen Then flag = False", _
"    For i = 7 To 21", _
"        If InputBox(n(6) & i + 21) <> n(i) Then flag = False", _
"    Next i", _
"    Debug.Print IIf(flag, 1, 0)", _
"End Sub")
    x = InputBox(n(5))
    flag = True
    For i = 0 To 5
        If InputBox(n(6) & i) <> n(i) Then flag = False
    Next i
    For i = 0 To 20
        If InputBox(n(6) & i + 6) <> quote & n(i) & quote & comma & cont Then flag = False
    Next i
    If InputBox(n(6) & 27) <> quote & n(21) & quote & rparen Then flag = False
    For i = 7 To 21
        If InputBox(n(6) & i + 21) <> n(i) Then flag = False
    Next i
    Debug.Print IIf(flag, 1, 0)
End Sub
