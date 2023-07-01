Imports System, System.Linq, System.Collections.Generic, System.Console

Module Module1

    Dim fmt As String = "{0,4} * {1,31:n0} = {2,-28}" & vbLf

    Sub B10(ByVal n As Integer)
        If n <= 1 Then Return
        Dim pow As Integer() = New Integer(n) {},
            val As Integer() = New Integer(n) {},
            count As Integer = 0, ten As Integer = 1, x As Integer = 1
        While x <= n : val(x) = ten : For j As Integer = 0 To n
                If pow(j) <> 0 AndAlso pow((j + ten) Mod n) = 0 AndAlso _
                   pow(j) <> x Then pow((j + ten) Mod n) = x
            Next : If pow(ten) = 0 Then pow(ten) = x
            ten = (10 * ten) Mod n : If pow(0) <> 0 Then
                x = n : Dim s As String = "" : While x <> 0
                    Dim p As Integer = pow(x Mod n)
                    If count > p Then s += New String("0"c, count - p)
                    count = p - 1 : s += "1"
                    x = (n + x - val(p)) Mod n : End While
                If count > 0 Then s += New String("0"c, count)
                Write(fmt, n, Decimal.Parse(s) / n, s) : Return
            End If : x += 1 : End While : Write("Can't do it!")
    End Sub

    Sub Main(ByVal args As String())
        Dim st As DateTime = DateTime.Now
        Dim m As List(Of Integer) = New List(Of Integer) From _
            {297,576,594,891,909,999,1998,2079,2251,2277,2439,2997,4878}
        Write(fmt, "n", "multiplier", "B10")
        WriteLine(New String("-"c, 69)) : Write(fmt, 1, 1, 1)
        For n As Integer = 1 To m.Last()
            If n <= 10 OrElse n >= 95 AndAlso n <= 105 OrElse m.Contains(n) Then B10(n)
        Next : WriteLine(vbLf & "Took {0}ms", (DateTime.Now - st).TotalMilliseconds)
    End Sub
End Module
