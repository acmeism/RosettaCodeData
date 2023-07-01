Module Module1

    Function GetGroup(s As String, depth As Integer) As Tuple(Of List(Of String), String)
        Dim out As New List(Of String)
        Dim comma = False
        While Not String.IsNullOrEmpty(s)
            Dim gs = GetItem(s, depth)
            Dim g = gs.Item1
            s = gs.Item2
            If String.IsNullOrEmpty(s) Then
                Exit While
            End If
            out.AddRange(g)

            If s(0) = "}" Then
                If comma Then
                    Return Tuple.Create(out, s.Substring(1))
                End If
                Return Tuple.Create(out.Select(Function(a) "{" + a + "}").ToList(), s.Substring(1))
            End If

            If s(0) = "," Then
                comma = True
                s = s.Substring(1)
            End If
        End While
        Return Nothing
    End Function

    Function GetItem(s As String, Optional depth As Integer = 0) As Tuple(Of List(Of String), String)
        Dim out As New List(Of String) From {""}
        While Not String.IsNullOrEmpty(s)
            Dim c = s(0)
            If depth > 0 AndAlso (c = "," OrElse c = "}") Then
                Return Tuple.Create(out, s)
            End If
            If c = "{" Then
                Dim x = GetGroup(s.Substring(1), depth + 1)
                If Not IsNothing(x) Then
                    Dim tout As New List(Of String)
                    For Each a In out
                        For Each b In x.Item1
                            tout.Add(a + b)
                        Next
                    Next
                    out = tout
                    s = x.Item2
                    Continue While
                End If
            End If
            If c = "\" AndAlso s.Length > 1 Then
                c += s(1)
                s = s.Substring(1)
            End If
            out = out.Select(Function(a) a + c).ToList()
            s = s.Substring(1)
        End While
        Return Tuple.Create(out, s)
    End Function

    Sub Main()
        For Each s In {
            "It{{em,alic}iz,erat}e{d,}, please.",
            "~/{Downloads,Pictures}/*.{jpg,gif,png}",
            "{,{,gotta have{ ,\, again\, }}more }cowbell!",
            "{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}"
        }
            Dim fmt = "{0}" + vbNewLine + vbTab + "{1}"
            Dim parts = GetItem(s)
            Dim res = String.Join(vbNewLine + vbTab, parts.Item1)
            Console.WriteLine(fmt, s, res)
        Next
    End Sub

End Module
