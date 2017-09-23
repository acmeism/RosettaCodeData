' Soundex
    tt=array( _
      "Ashcraft","Ashcroft","Gauss","Ghosh","Hilbert","Heilbronn","Lee","Lloyd", _
      "Moses","Pfister","Robert","Rupert","Rubin","Tymczak","Soundex","Example")
    tv=array( _
      "A261","A261","G200","G200","H416","H416","L000","L300", _
      "M220","P236","R163","R163","R150","T522","S532","E251")
    For i=lbound(tt) To ubound(tt)
        ts=soundex(tt(i))
        If ts<>tv(i) Then ok=" KO "& tv(i) Else ok=""
        Wscript.echo right(" "& i ,2) & " " & left( tt(i) &space(12),12) & " " & ts & ok
    Next 'i

Function getCode(c)
    Select Case c
        Case "B", "F", "P", "V"
            getCode = "1"
        Case "C", "G", "J", "K", "Q", "S", "X", "Z"
            getCode = "2"
        Case "D", "T"
            getCode = "3"
        Case "L"
            getCode = "4"
        Case "M", "N"
            getCode = "5"
        Case "R"
            getCode = "6"
        Case "W","H"
            getCode = "-"
    End Select
End Function 'getCode

Function soundex(s)
    Dim code, previous, i
    code = UCase(Mid(s, 1, 1))
    previous = getCode(UCase(Mid(s, 1, 1)))
    For i = 2 To Len(s)
        current = getCode(UCase(Mid(s, i, 1)))
        If current <> "" And current <> "-" And current <> previous Then code = code & current
        If current <> "-" Then previous = current
    Next 'i
    soundex = Mid(code & "000", 1, 4)
End Function 'soundex
