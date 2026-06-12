Module Module1

    Structure UserInput
        ReadOnly FormFeed As Char
        ReadOnly LineFeed As Char
        ReadOnly Tab As Char
        ReadOnly Space As Char

        Sub New(ff As String, lf As String, tb As String, sp As String)
            FormFeed = ChrW(Integer.Parse(ff))
            LineFeed = ChrW(Integer.Parse(lf))
            Tab = ChrW(Integer.Parse(tb))
            Space = ChrW(Integer.Parse(sp))
        End Sub
    End Structure

    Function GetUserInput() As List(Of UserInput)
        Dim h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " &
            "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"
        Return h.Split(" ") _
            .Select(Function(x, idx) New With {x, idx}) _
            .GroupBy(Function(x) x.idx \ 4) _
            .Select(Function(g)
                        Dim ge = g.Select(Function(a) a.x).ToArray()
                        Return New UserInput(ge(0), ge(1), ge(2), ge(3))
                    End Function) _
                    .ToList()
    End Function

    Sub Decode(filename As String, uiList As List(Of UserInput))
        Dim text = IO.File.ReadAllText(filename)

        Dim Inc = Function(a As Char) As Char
                      Return ChrW(AscW(a) + 1)
                  End Function

        Dim DecodeImpl = Function(ui As UserInput) As Boolean
                             Dim f = ChrW(0)
                             Dim l = ChrW(0)
                             Dim t = ChrW(0)
                             Dim s = ChrW(0)

                             For Each c In text
                                 If f = ui.FormFeed AndAlso l = ui.LineFeed AndAlso t = ui.Tab AndAlso s = ui.Space Then
                                     If c = "!" Then
                                         Return False
                                     End If
                                     Console.Write(c)
                                     Return True
                                 End If
                                 If vbFormFeed = c Then
                                     f = Inc(f)
                                     l = ChrW(0)
                                     t = ChrW(0)
                                     s = ChrW(0)
                                 ElseIf vbLf = c Then
                                     l = Inc(l)
                                     t = ChrW(0)
                                     s = ChrW(0)
                                 ElseIf vbTab = c Then
                                     t = Inc(t)
                                     s = ChrW(0)
                                 Else
                                     s = Inc(s)
                                 End If
                             Next

                             Return False
                         End Function

        For Each ui In uiList
            If Not DecodeImpl(ui) Then
                Exit For
            End If
        Next

        Console.WriteLine()
    End Sub

    Sub Main()
        Dim uiList = GetUserInput()
        Decode("theRaven.txt", uiList)
    End Sub

End Module
