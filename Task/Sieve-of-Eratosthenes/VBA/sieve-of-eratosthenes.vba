 Sub primes()
'BRRJPA
'Prime calculation for VBA_Excel
'p is the superior limit of the range calculation
'This example calculates from 2 to 100000 and print it
'at the collum A


p = 100000

Dim nprimes(1 To 100000) As Integer
b = Sqr(p)

For n = 2 To b

    For k = n * n To p Step n
        nprimes(k) = 1

    Next k
Next n


For a = 2 To p
    If nprimes(a) = 0 Then
      c = c + 1
      Range("A" & c).Value = a

    End If
 Next a

End Sub
