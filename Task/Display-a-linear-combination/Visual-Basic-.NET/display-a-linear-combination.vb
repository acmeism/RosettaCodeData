Imports System.Text

Module Module1

    Function LinearCombo(c As List(Of Integer)) As String
        Dim sb As New StringBuilder
        For i = 0 To c.Count - 1
            Dim n = c(i)
            If n < 0 Then
                If sb.Length = 0 Then
                    sb.Append("-")
                Else
                    sb.Append(" - ")
                End If
            ElseIf n > 0 Then
                If sb.Length <> 0 Then
                    sb.Append(" + ")
                End If
            Else
                Continue For
            End If

            Dim av = Math.Abs(n)
            If av <> 1 Then
                sb.AppendFormat("{0}*", av)
            End If
            sb.AppendFormat("e({0})", i + 1)
        Next
        If sb.Length = 0 Then
            sb.Append("0")
        End If
        Return sb.ToString()
    End Function

    Sub Main()
        Dim combos = New List(Of List(Of Integer)) From {
            New List(Of Integer) From {1, 2, 3},
            New List(Of Integer) From {0, 1, 2, 3},
            New List(Of Integer) From {1, 0, 3, 4},
            New List(Of Integer) From {1, 2, 0},
            New List(Of Integer) From {0, 0, 0},
            New List(Of Integer) From {0},
            New List(Of Integer) From {1, 1, 1},
            New List(Of Integer) From {-1, -1, -1},
            New List(Of Integer) From {-1, -2, 0, -3},
            New List(Of Integer) From {-1}
        }

        For Each c In combos
            Dim arr = "[" + String.Join(", ", c) + "]"
            Console.WriteLine("{0,15} -> {1}", arr, LinearCombo(c))
        Next
    End Sub

End Module
