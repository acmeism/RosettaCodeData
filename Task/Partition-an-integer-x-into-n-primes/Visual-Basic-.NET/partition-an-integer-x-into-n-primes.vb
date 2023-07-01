' Partition an integer X into N primes - 29/03/2017
Option Explicit On

Module PartitionIntoPrimes
    Dim p(8), a(32), b(32), v, g, q As Long

    Sub Main()
        Dim what, t1(), t2(), t3(), xx, nn As String
        Dim x, y, n, m As Long
        what = "99809 1  18 2  19 3  20 4  2017 24  22699 1-4  40355 3"
        t1 = Split(what, "  ")
        For j = 0 To UBound(t1)
            t2 = Split(t1(j)) : xx = t2(0) : nn = t2(1)
            t3 = Split(xx, "-") : x = CLng(t3(0))
            If UBound(t3) = 1 Then y = CLng(t3(1)) Else y = x
            t3 = Split(nn, "-") : n = CLng(t3(0))
            If UBound(t3) = 1 Then m = CLng(t3(1)) Else m = n
            genp(y) 'generate primes in p
            For g = x To y
                For q = n To m : part() : Next 'q
            Next 'g
        Next 'j
    End Sub 'Main

    Sub genp(high As Long)
        Dim c, i, k As Long
        Dim bk As Boolean
        p(1) = 2 : p(2) = 3 : c = 2 : i = p(c) + 2
        Do 'i
            k = 2 : bk = False
            Do While k * k <= i And Not bk 'k
                If i Mod p(k) = 0 Then bk = True
                k = k + 1
            Loop 'k
            If Not bk Then
                c = c + 1 : If c > UBound(p) Then ReDim Preserve p(UBound(p) + 8)
                p(c) = i
            End If
            i = i + 2
        Loop Until p(c) > high 'i
    End Sub 'genp

    Sub getp(z As Long)
        Dim w As Long
        If a(z) = 0 Then w = z - 1 : a(z) = a(w)
        a(z) = a(z) + 1 : w = a(z) : b(z) = p(w)
    End Sub 'getp

    Function list()
        Dim w As String
        w = b(1)
        If v = g Then
            For i = 2 To q : w = w & "+" & b(i) : Next
        Else
            w = "(not possible)"
        End If
        Return "primes: " & w
    End Function 'list

    Sub part()
        For i = LBound(a) To UBound(a) : a(i) = 0 : Next 'i
        For i = 1 To q : Call getp(i) : Next 'i
        Do While True : v = 0
            For s = 1 To q
                v = v + b(s)
                If v > g Then
                    If s = 1 Then Exit Do
                    For k = s To q : a(k) = 0 : Next 'k
                    For r = s - 1 To q : Call getp(r) : Next 'r
                    Continue Do
                End If
            Next 's
            If v = g Then Exit Do
            If v < g Then Call getp(q)
        Loop
        Console.WriteLine("partition " & g & " into " & q & " " & list())
    End Sub 'part

End Module 'PartitionIntoPrimes
