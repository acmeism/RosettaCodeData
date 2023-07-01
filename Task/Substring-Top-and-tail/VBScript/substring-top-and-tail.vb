Function TopNTail(s,mode)
    Select Case mode
        Case "top"
            TopNTail = Mid(s,2,Len(s)-1)
        Case "tail"
            TopNTail = Mid(s,1,Len(s)-1)
        Case "both"
            TopNTail = Mid(s,2,Len(s)-2)
    End Select
End Function

WScript.Echo "Top: UPRAISERS = " & TopNTail("UPRAISERS","top")
WScript.Echo "Tail: UPRAISERS = " & TopNTail("UPRAISERS","tail")
WScript.Echo "Both: UPRAISERS = " & TopNTail("UPRAISERS","both")
