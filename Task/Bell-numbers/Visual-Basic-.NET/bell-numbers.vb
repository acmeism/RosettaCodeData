Imports System.Numerics
Imports System.Runtime.CompilerServices

Module Module1

    <Extension()>
    Sub Init(Of T)(array As T(), value As T)
        If IsNothing(array) Then Return
        For i = 0 To array.Length - 1
            array(i) = value
        Next
    End Sub

    Function BellTriangle(n As Integer) As BigInteger()()
        Dim tri(n - 1)() As BigInteger
        For i = 0 To n - 1
            Dim temp(i - 1) As BigInteger
            tri(i) = temp
            tri(i).Init(0)
        Next
        tri(1)(0) = 1
        For i = 2 To n - 1
            tri(i)(0) = tri(i - 1)(i - 2)
            For j = 1 To i - 1
                tri(i)(j) = tri(i)(j - 1) + tri(i - 1)(j - 1)
            Next
        Next
        Return tri
    End Function

    Sub Main()
        Dim bt = BellTriangle(51)
        Console.WriteLine("First fifteen Bell numbers:")
        For i = 1 To 15
            Console.WriteLine("{0,2}: {1}", i, bt(i)(0))
        Next
        Console.WriteLine("50: {0}", bt(50)(0))
        Console.WriteLine()
        Console.WriteLine("The first ten rows of Bell's triangle:")
        For i = 1 To 10
            Dim it = bt(i).GetEnumerator()
            Console.Write("[")
            If it.MoveNext() Then
                Console.Write(it.Current)
            End If
            While it.MoveNext()
                Console.Write(", ")
                Console.Write(it.Current)
            End While
            Console.WriteLine("]")
        Next
    End Sub

End Module
