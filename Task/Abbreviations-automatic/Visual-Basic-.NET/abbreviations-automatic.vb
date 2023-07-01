Module Module1

    Sub Main()
        Dim lines = IO.File.ReadAllLines("days_of_week.txt")
        Dim i = 0

        For Each line In lines
            i += 1
            If line.Length > 0 Then
                Dim days = line.Split()
                If days.Length <> 7 Then
                    Throw New Exception("There aren't 7 days in line " + i)
                End If

                Dim temp As New Dictionary(Of String, Integer)
                For Each d In days
                    If temp.ContainsKey(d) Then
                        Console.WriteLine(" ∞  {0}", line)
                        Continue For
                    End If
                    temp.Add(d, 1)
                Next

                Dim len = 1
                Do
                    temp.Clear()
                    For Each d In days
                        Dim key As String
                        If len < d.Length Then
                            key = d.Substring(0, len)
                        Else
                            key = d
                        End If
                        If temp.ContainsKey(key) Then
                            Exit For
                        End If
                        temp.Add(key, 1)
                    Next
                    If temp.Count = 7 Then
                        Console.WriteLine("{0,2:D}  {1}", len, line)
                        Exit Do
                    End If
                    len += 1
                Loop
            End If
        Next
    End Sub

End Module
