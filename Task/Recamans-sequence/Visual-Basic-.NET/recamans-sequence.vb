Imports System
Imports System.Collections.Generic

Module Module1
    Sub Main(ByVal args As String())
        Dim a As List(Of Integer) = New List(Of Integer)() From { 0 },
            used As HashSet(Of Integer) = New HashSet(Of Integer)() From { 0 },
            used1000 As HashSet(Of Integer) = used.ToHashSet(),
            foundDup As Boolean = False
        For n As Integer = 1 to Integer.MaxValue
            Dim nv As Integer = a(n - 1) - n
            If nv < 1 OrElse used.Contains(nv) Then nv += 2 * n
            Dim alreadyUsed As Boolean = used.Contains(nv) : a.Add(nv)
            If Not alreadyUsed Then used.Add(nv) : If nv > 0 AndAlso nv <= 1000 Then used1000.Add(nv)
            If Not foundDup Then
                If a.Count = 15 Then _
                    Console.WriteLine("The first 15 terms of the Recamán sequence are: ({0})", String.Join(", ", a))
                If alreadyUsed Then _
                    Console.WriteLine("The first duplicated term is a({0}) = {1}", n, nv) : foundDup = True
            End If
            If used1000.Count = 1001 Then _
                Console.WriteLine("Terms up to a({0}) are needed to generate 0 to 1000", n) : Exit For
        Next
    End Sub
End Module
