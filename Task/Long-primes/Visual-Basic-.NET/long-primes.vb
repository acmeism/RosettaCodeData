Imports System, System.Collections.Generic, System.Linq, System.Console

Module LongPrimes

    Function Period(ByVal n As Integer) As Integer
        Dim m As Integer, r As Integer = 1
        For i As Integer = 0 To n : r = 10 * r Mod n : Next
        m = r : Period = 1 : While True
            r = (10 * r) Mod n : If r = m Then Return Period
            Period += 1 : End While
    End Function

    Sub Main()
        Dim primes As IEnumerable(Of Integer) = SomePrimeGenerator.Primes(64000).Skip(1).Where(Function(p) Period(p) = p - 1).Append(99999)
        Dim count As Integer = 0, limit As Integer = 500
        WriteLine(String.Join(" ", primes.TakeWhile(Function(p) p <= limit)))
        For Each prime As Integer In primes
            If prime > limit Then
                WriteLine($"There are {count} long primes below {limit}")
                limit <<= 1 : End If : count += 1 : Next
    End Sub

End Module

Module SomePrimeGenerator

    Iterator Function Primes(lim As Integer) As IEnumerable(Of Integer)
        Dim flags As Boolean() = New Boolean(lim) {},
            j As Integer = 2, d As Integer = 3, sq As Integer = 4
        While sq <= lim
            If Not flags(j) Then
                Yield j : For k As Integer = sq To lim step j
                    flags(k) = True : Next
            End If : j += 1 : d += 2 : sq += d
        End While : While j <= lim
            If Not flags(j) Then Yield j
            j += 1 : End While
    End Function

End Module
