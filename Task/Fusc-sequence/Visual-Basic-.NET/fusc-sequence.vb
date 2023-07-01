Module Module1

    Dim n As Integer = 61, l As List(Of Integer) = {0, 1}.ToList

    Function fusc(n As Integer) As Integer
        If n < l.Count Then Return l(n)
        fusc = If((n And 1) = 0, l(n >> 1), l((n - 1) >> 1) + l((n + 1) >> 1))
        l.Add(fusc)
    End Function

    Sub Main(args As String())
        Dim lst As Boolean = True, w As Integer = -1, c As Integer = 0,
            fs As String = "{0,11:n0}  {1,-9:n0}", res As String = ""
        Console.WriteLine("First {0} numbers in the fusc sequence:", n)
        For i As Integer = 0 To Integer.MaxValue
            Dim f As Integer = fusc(i)
            If lst Then
                If i < 61 Then
                    Console.Write("{0} ", f)
                Else
                    lst = False
                    Console.WriteLine()
                    Console.WriteLine("Points in the sequence where an item has more digits than any previous items:")
                    Console.WriteLine(fs, "Index\", "/Value") : Console.WriteLine(res) : res = ""
                End If
            End If
            Dim t As Integer = f.ToString.Length
            If t > w Then
                w = t
                res &= If(res = "", "", vbLf) & String.Format(fs, i, f)
                If Not lst Then Console.WriteLine(res) : res = ""
                c += 1 : If c > 5 Then Exit For
            End If
        Next : l.Clear()
    End Sub
End Module
