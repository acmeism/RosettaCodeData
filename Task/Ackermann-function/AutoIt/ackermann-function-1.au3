Func Ackermann($m, $n)
    If ($m = 0) Then
        Return $n+1
    Else
        If ($n = 0) Then
            Return Ackermann($m-1, 1)
        Else
            return Ackermann($m-1, Ackermann($m, $n-1))
        EndIf
    EndIf
EndFunc
