Function PartitionsP(n As UInteger) As ULongInt
    ' if n > 416, the result becomes to large for a unsigned 64bit integer
    Dim As ULongInt p(n)
    Dim As UInteger k, j

    p(0) = 1
    For i As UInteger = 1 To n
        k = 0
        While TRUE
            k += 1
            j = (k * (3*k - 1)) \ 2
            If (j > i) Then Exit While
            If (k And 1) Then
                p(i) += p(i - j)
            Else
                p(i) -= p(i - j)
            End If
            'j = (k * (3*k + 1)) \ 2
            j += k
            If (j > i) Then Exit While
            If (k And 1) Then
                p(i) += p(i - j)
            Else
                p(i) -= p(i - j)
            End If
        Wend
    Next i
    Return p(n)
End Function

Print !"\nPartitionsP: ";
For x As UInteger = 0 To 12
    Print PartitionsP(x);"  ";
Next x

Print !"\n\ndone"
Sleep
