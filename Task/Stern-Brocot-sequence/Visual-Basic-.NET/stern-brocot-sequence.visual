Imports System
Imports System.Collections.Generic
Imports System.Linq

Module Module1
    Dim l As List(Of Integer) = {1, 1}.ToList()

    Function gcd(ByVal a As Integer, ByVal b As Integer) As Integer
        Return If(a > 0, If(a < b, gcd(b Mod a, a), gcd(a Mod b, b)), b)
    End Function

    Sub Main(ByVal args As String())
        Dim max As Integer = 1000, take As Integer = 15, i As Integer = 1,
            selection As Integer() = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100}
        Do : l.AddRange({l(i) + l(i - 1), l(i)}.ToList) : i += 1
        Loop While l.Count < max OrElse l(l.Count - 2) <> selection.Last()
        Console.Write("The first {0} items In the Stern-Brocot sequence: ", take)
        Console.WriteLine("{0}" & vbLf, String.Join(", ", l.Take(take)))
        Console.WriteLine("The locations of where the selected numbers (1-to-10, & 100) first appear:")
        For Each ii As Integer In selection
            Dim j As Integer = l.FindIndex(Function(x) x = ii) + 1
            Console.WriteLine("{0,3}: {1:n0}", ii, j)
        Next : Console.WriteLine() : Dim good As Boolean = True : For i = 1 To max
            If gcd(l(i), l(i - 1)) <> 1 Then good = False : Exit For
        Next
        Console.WriteLine("The greatest common divisor of all the two consecutive items of the" &
                          " series up to the {0}th item is {1}always one.", max, If(good, "", "not "))
    End Sub
End Module
