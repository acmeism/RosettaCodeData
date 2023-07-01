Imports System.Console

Namespace safety
    Module SafePrimes
        Dim pri_HS As HashSet(Of Integer) = Primes(10_000_000).ToHashSet()

        Sub Main()
            For Each UnSafe In {False, True} : Dim n As Integer = If(UnSafe, 40, 35)
                WriteLine($"The first {n} {If(UnSafe, "un", "")}safe primes are:")
                WriteLine(String.Join(" ", pri_HS.Where(Function(p) UnSafe Xor
                                                            pri_HS.Contains(p \ 2)).Take(n)))
            Next : Dim limit As Integer = 1_000_000 : Do
                Dim part = pri_HS.TakeWhile(Function(l) l < limit),
                 sc As Integer = part.Count(Function(p) pri_HS.Contains(p \ 2))
                WriteLine($"Of the primes below {limit:n0}: {sc:n0} are safe, and {part.Count() -
                          sc:n0} are unsafe.") : If limit = 1_000_000 Then limit *= 10 Else Exit Do
            Loop
        End Sub

        Private Iterator Function Primes(ByVal bound As Integer) As IEnumerable(Of Integer)
            If bound < 2 Then Return
            Yield 2
            Dim composite As BitArray = New BitArray((bound - 1) \ 2)
            Dim limit As Integer = (CInt((Math.Sqrt(bound))) - 1) \ 2
            For i As Integer = 0 To limit - 1 : If composite(i) Then Continue For
                Dim prime As Integer = 2 * i + 3 : Yield prime
                Dim j As Integer = (prime * prime - 2) \ 2
                While j < composite.Count : composite(j) = True : j += prime : End While
            Next
            For i As integer = limit To composite.Count - 1 : If Not composite(i) Then Yield 2 * i + 3
            Next
        End Function
    End Module
End Namespace
