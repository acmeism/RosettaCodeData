Imports System.Text

Module Module1

    Dim games As New List(Of String) From {"12", "13", "14", "23", "24", "34"}
    Dim results = "000000"

    Function FromBase3(num As String) As Integer
        Dim out = 0
        For Each c In num
            Dim d = Asc(c) - Asc("0"c)
            out = 3 * out + d
        Next
        Return out
    End Function

    Function ToBase3(num As Integer) As String
        Dim ss As New StringBuilder

        While num > 0
            Dim re = num Mod 3
            num \= 3
            ss.Append(re)
        End While

        Return New String(ss.ToString().Reverse().ToArray())
    End Function

    Function NextResult() As Boolean
        If results = "222222" Then
            Return False
        End If

        Dim res = FromBase3(results)

        Dim conv = ToBase3(res + 1)
        results = conv.PadLeft(6, "0"c)

        Return True
    End Function

    Sub Main()
        Dim points(0 To 3, 0 To 9) As Integer
        Do
            Dim records(0 To 3) As Integer
            For index = 0 To games.Count - 1
                Select Case results(index)
                    Case "2"c
                        records(Asc(games(index)(0)) - Asc("1"c)) += 3
                    Case "1"c
                        records(Asc(games(index)(0)) - Asc("1"c)) += 1
                        records(Asc(games(index)(1)) - Asc("1"c)) += 1
                    Case "0"c
                        records(Asc(games(index)(1)) - Asc("1"c)) += 3
                End Select
            Next

            Array.Sort(records)
            For index = 0 To records.Length - 1
                Dim t = records(index)
                points(index, t) += 1
            Next
        Loop While NextResult()

        Console.WriteLine("POINTS       0    1    2    3    4    5    6    7    8    9")
        Console.WriteLine("-------------------------------------------------------------")
        Dim places As New List(Of String) From {"1st", "2nd", "3rd", "4th"}
        For i = 0 To places.Count - 1
            Console.Write("{0} place", places(i))
            For j = 0 To 9
                Console.Write("{0,5}", points(3 - i, j))
            Next
            Console.WriteLine()
        Next
    End Sub

End Module
