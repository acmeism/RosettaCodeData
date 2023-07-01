Imports System.Linq
Module Module1
    Dim h() As Integer
    Sub sho(i As Integer)
        Console.WriteLine(String.Join(" ", h.Skip(i).Take(10)))
    End Sub
    Sub Main()
        Dim a, b, c, d, f, g As Integer : g = 1000
        h = new Integer(g){} : a = 0 : b = 1 : For c = 2 To g
            f = h(b) : For d = a To 0 Step -1
                If f = h(d) Then h(c) = b - d: Exit For
            Next : a = b : b = c : Next : sho(0) : sho(990)
    End Sub
End Module
