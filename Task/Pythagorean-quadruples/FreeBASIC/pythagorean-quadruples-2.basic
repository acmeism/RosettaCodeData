' version 14-08-2017
' compile with: fbc -s console

#Define n 2200

Dim As UInteger s = 3, s1, s2, x, x2, y
ReDim As Ubyte l(n), l_add(n * n * 2)

For x = 1 To n
    x2 = x * x
    For y = x To n
        l_add(x2 + y * y) = 1
    Next
Next

For x = 1 To n
    s1 = s
    s += 2
    s2 = s
    For y = x +1 To n
        If l_add(s1) = 1 Then l(y) = 1
        s1 += s2
        s2 += 2
    Next
Next

For x = 1 To n
    If l(x) = 0 Then Print Str(x); " ";
Next
Print

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
