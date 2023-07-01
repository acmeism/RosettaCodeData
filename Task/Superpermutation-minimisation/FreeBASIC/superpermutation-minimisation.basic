' version 28-06-2018
' compile with: fbc -s console

Function superpermsize(n As UInteger) As UInteger

    Dim As UInteger x, y, sum, fac
    For x = 1 To n
        fac = 1
        For y = 1 To x
            fac *= y
        Next
        sum += fac
    Next

    Function = sum

End Function

Function superperm(n As UInteger) As String

    If n = 1 Then Return "1"

    Dim As String sup_perm = "1", insert
    Dim As String p, q()
    Dim As UInteger a, b, i, l, x

    For x = 2 To n
        insert = IIf(x < 10, Str(x), Chr(x + 55))
        l = Len(sup_perm)
        If l > 1 Then l = Len(sup_perm) - x +2
        ReDim q(l)
        For i = 1 To l
            p = Mid(sup_perm, i, x -1)
            If x > 2 Then
            For a = 0 To Len(p) -2
                For b = a+1 To Len(p) -1
                    If p[a] = p[b] Then Continue For, For, For
                Next
            Next
            End If
            q(i) = p + insert + p
        Next
        sup_perm = q(1)
        For i = 2 To UBound(q)
            a = x -1
            Do
                If Right(sup_perm, a) = Left(q(i), a) Then
                    sup_perm += Mid(q(i), a +1)
                    Exit Do
                End If
                a -= 1
            Loop
        Next
    Next

    Function = sup_perm

End Function

' ------=< MAIN >=------

Dim As String superpermutation
Dim As UInteger n

For n = 1 To 10
    superpermutation = superperm(n)
    Print Using "### ######## ########   "; n; superpermsize(n); Len(superpermutation);
    If n < 5 Then
        Print superpermutation
    Else
        Print
    End If
Next

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
