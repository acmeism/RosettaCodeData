'Execute BrainFuck
'VBScript Implementation

'The Main Interpreter
Function BFInpt(s, sp, d, dp, i, ip, o)
    While sp < Len(s)
        Select Case Mid(s, sp + 1, 1)
            Case "+"
                newd = Asc(d(dp)) + 1
                If newd > 255 Then newd = newd Mod 256    'To take account of values over 255
                d(dp) = Chr(newd)
            Case "-"
                newd = Asc(d(dp)) - 1
                If newd < 0 Then newd = (newd Mod 256) + 256    'To take account of negative values
                d(dp) = Chr(newd)
            Case ">"
                dp = dp + 1
                If dp > UBound(d) Then
                    ReDim Preserve d(UBound(d) + 1)
                    d(dp) = Chr(0)
                End If
            Case "<"
                dp = dp - 1
            Case "."
                o = o & d(dp)
            Case ","
                If ip = Len(i) Then d(dp) = Chr(0) Else ip = ip + 1 : d(dp) = Mid(i, ip, 1)
            Case "["
                If Asc(d(dp)) = 0 Then
                    bracket = 1
                    While bracket And sp < Len(s)
                        sp = sp + 1
                        If Mid(s, sp + 1, 1) = "[" Then
                            bracket = bracket + 1
                        ElseIf Mid(s, sp + 1, 1) = "]" Then
                            bracket = bracket - 1
                        End If
                    WEnd
                Else
                    pos = sp - 1
                    sp = sp + 1
                    If BFInpt(s, sp, d, dp, i, ip, o) Then sp = pos
                End If
            Case "]"
                BFInpt = Asc(d(dp)) <> 0
                Exit Function
        End Select
        sp = sp + 1
    WEnd
End Function

'This Prepares the Intepreter
Function BFuck(source, input)
    Dim data() : ReDim data(0)
    data(0)  = Chr(0)
    DataPtr  = 0
    SrcPtr   = 0
    InputPtr = 0
    output   = ""

    BFInpt source , SrcPtr   , _
           data   , DataPtr  , _
           input  , InputPtr , _
           output
    BFuck = output
End Function


'Sample Run
'The input is a string. The first character will be scanned by the first comma
'in the code, the next character will be scanned by the next comma, and so on.

code   = ">++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>" & _
         ">+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++."
inpstr = ""
WScript.StdOut.Write BFuck(code, inpstr)
