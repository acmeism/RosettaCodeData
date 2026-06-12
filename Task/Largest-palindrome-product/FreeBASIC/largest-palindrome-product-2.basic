' version 07-10-2021
' compile with: fbc -s console

' Now you can choice, no speed changes for all 3
' 1: use goto
' 2: use exit
' 3: use continue
#Define Option_ 1  ' set option_ to 1, 2 or 3. for all other value's uses 1

Function make_pal( n As UInteger ) As ULongInt
    'turn a number into a palindrom with twice as many digits
    Dim As String ns = Str(n), ret = ns
    For i As UInteger = Len(ns) To 1 Step -1
        ret += Mid(ns, i, 1)
    Next i
    Return ValULng(ret)
End Function

Dim As ULongInt np, tmp
Dim As Double t1 =Timer
For d As UInteger = 2 To 9
    For n As UInteger = 10^d -2 To 10^(d -1) Step -1
        np = make_pal( n )
        tmp = Sqr(np)
        tmp = tmp - (10^d - 1 - tmp)
        tmp = tmp - tmp Mod 11
        If (tmp And 1) = 0 Then tmp = tmp + 11
        For f As UInteger = tmp To 10^d -1  Step 22
            If np Mod f = 0 Then
                If np \ f > (10^d) Then Continue For
                Print f; " * "; np \ f; " = "; np
                #If (option_ = 2)
                    Exit For, For
                #ElseIf (option_ = 3)
                    Continue For, For, For
                #Else
                    GoTo nextd
                #EndIf
            End If
        Next f
    Next n
    #If (option_ <> 2 Or option_ <> 3)
        nextd:
    #EndIf
Next d

Print Timer-t1
' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
