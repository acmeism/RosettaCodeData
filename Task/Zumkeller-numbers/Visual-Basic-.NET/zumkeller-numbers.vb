Module Module1
    Function GetDivisors(n As Integer) As List(Of Integer)
        Dim divs As New List(Of Integer) From {
            1, n
        }
        Dim i = 2
        While i * i <= n
            If n Mod i = 0 Then
                Dim j = n \ i
                divs.Add(i)
                If i <> j Then
                    divs.Add(j)
                End If
            End If
            i += 1
        End While
        Return divs
    End Function

    Function IsPartSum(divs As List(Of Integer), sum As Integer) As Boolean
        If sum = 0 Then
            Return True
        End If
        Dim le = divs.Count
        If le = 0 Then
            Return False
        End If
        Dim last = divs(le - 1)
        Dim newDivs As New List(Of Integer)
        For i = 1 To le - 1
            newDivs.Add(divs(i - 1))
        Next
        If last > sum Then
            Return IsPartSum(newDivs, sum)
        End If
        Return IsPartSum(newDivs, sum) OrElse IsPartSum(newDivs, sum - last)
    End Function

    Function IsZumkeller(n As Integer) As Boolean
        Dim divs = GetDivisors(n)
        Dim sum = divs.Sum()
        REM if sum is odd can't be split into two partitions with equal sums
        If sum Mod 2 = 1 Then
            Return False
        End If
        REM if n is odd use 'abundant odd number' optimization
        If n Mod 2 = 1 Then
            Dim abundance = sum - 2 * n
            Return abundance > 0 AndAlso abundance Mod 2 = 0
        End If
        REM if n and sum are both even check if there's a partition which totals sum / 2
        Return IsPartSum(divs, sum \ 2)
    End Function

    Sub Main()
        Console.WriteLine("The first 220 Zumkeller numbers are:")
        Dim i = 2
        Dim count = 0
        While count < 220
            If IsZumkeller(i) Then
                Console.Write("{0,3} ", i)
                count += 1
                If count Mod 20 = 0 Then
                    Console.WriteLine()
                End If
            End If
            i += 1
        End While
        Console.WriteLine()

        Console.WriteLine("The first 40 odd Zumkeller numbers are:")
        i = 3
        count = 0
        While count < 40
            If IsZumkeller(i) Then
                Console.Write("{0,5} ", i)
                count += 1
                If count Mod 10 = 0 Then
                    Console.WriteLine()
                End If
            End If
            i += 2
        End While
        Console.WriteLine()

        Console.WriteLine("The first 40 odd Zumkeller numbers which don't end in 5 are:")
        i = 3
        count = 0
        While count < 40
            If i Mod 10 <> 5 AndAlso IsZumkeller(i) Then
                Console.Write("{0,7} ", i)
                count += 1
                If count Mod 8 = 0 Then
                    Console.WriteLine()
                End If
            End If
            i += 2
        End While
    End Sub
End Module
