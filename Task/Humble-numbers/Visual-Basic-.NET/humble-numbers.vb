Module Module1

    Function IsHumble(i As Long) As Boolean
        If i <= 1 Then
            Return True
        End If
        If i Mod 2 = 0 Then
            Return IsHumble(i \ 2)
        End If
        If i Mod 3 = 0 Then
            Return IsHumble(i \ 3)
        End If
        If i Mod 5 = 0 Then
            Return IsHumble(i \ 5)
        End If
        If i Mod 7 = 0 Then
            Return IsHumble(i \ 7)
        End If
        Return False
    End Function

    Sub Main()
        Dim LIMIT = Short.MaxValue
        Dim humble As New Dictionary(Of Integer, Integer)
        Dim count = 0L
        Dim num = 1L

        While count < LIMIT
            If (IsHumble(num)) Then
                Dim str = num.ToString
                Dim len = str.Length
                If len > 10 Then
                    Exit While
                End If
                If humble.ContainsKey(len) Then
                    humble(len) += 1
                Else
                    humble(len) = 1
                End If
                If count < 50 Then
                    Console.Write("{0} ", num)
                End If
                count += 1
            End If
            num += 1
        End While
        Console.WriteLine(vbNewLine)

        Console.WriteLine("Of the first {0} humble numbers:", count)
        num = 1
        While num < humble.Count
            If humble.ContainsKey(num) Then
                Dim c = humble(num)
                Console.WriteLine("{0,5} have {1,2} digits", c, num)
                num += 1
            Else
                Exit While
            End If
        End While
    End Sub

End Module
