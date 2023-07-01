Imports System.Runtime.CompilerServices

Module Module1
    <Extension()>
    Function ToHashSet(Of T)(source As IEnumerable(Of T)) As HashSet(Of T)
        Return New HashSet(Of T)(source)
    End Function

    <Extension()>
    Function Reverse(number As Integer) As Integer
        If number < 0 Then
            Return -Reverse(-number)
        End If
        If number < 10 Then
            Return number
        End If

        Dim rev = 0
        While number > 0
            rev = rev * 10 + number Mod 10
            number = number \ 10
        End While

        Return rev
    End Function

    <Extension()>
    Function Delimit(Of T)(source As IEnumerable(Of T), Optional seperator As String = " ") As String
        Return String.Join(If(seperator, " "), source)
    End Function

    Iterator Function Primes(bound As Integer) As IEnumerable(Of Integer)
        If bound < 2 Then
            Return
        End If
        Yield 2

        Dim composite As New BitArray((bound - 1) / 2)
        Dim limit As Integer = Int((Int(Math.Sqrt(bound)) - 1) / 2)
        For i = 0 To limit - 1
            If composite(i) Then
                Continue For
            End If
            Dim prime = 2 * i + 3
            Yield prime

            For j As Integer = Int((prime * prime - 2) / 2) To composite.Count - 1 Step prime
                composite(j) = True
            Next
        Next
        For i = limit To composite.Count - 1
            If Not composite(i) Then
                Yield 2 * i + 3
            End If
        Next
    End Function

    Iterator Function FindEmirpPrimes(limit As Integer) As IEnumerable(Of Integer)
        Dim ps = Primes(limit).ToHashSet()

        For Each p In ps
            Dim rev = p.Reverse()
            If rev <> p AndAlso ps.Contains(rev) Then
                Yield p
            End If
        Next
    End Function

    Sub Main()
        Dim limit = 1_000_000
        Console.WriteLine("First 20:")
        Console.WriteLine(FindEmirpPrimes(limit).Take(20).Delimit())
        Console.WriteLine()

        Console.WriteLine("Between 7700 and 8000:")
        Console.WriteLine(FindEmirpPrimes(limit).SkipWhile(Function(p) p < 7700).TakeWhile(Function(p) p < 8000).Delimit())
        Console.WriteLine()

        Console.WriteLine("10000th:")
        Console.WriteLine(FindEmirpPrimes(limit).ElementAt(9999))
    End Sub

End Module
