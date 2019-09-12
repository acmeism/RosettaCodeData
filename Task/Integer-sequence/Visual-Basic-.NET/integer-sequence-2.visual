Imports System.Console

Module Module1

    Dim base, b1 As Long, digits As Integer, sf As String, st As DateTime,
        ar As List(Of Long) = {0L}.ToList, c As Integer = ar.Count - 1

    Sub Increment(n As Integer)
        If ar(n) < b1 Then
            ar(n) += 1
        Else
            ar(n) = 0 : If n > 0 Then
                Increment(n - 1)
            Else
                Try
                    ar.Insert(0, 1L) : c += 1
                Catch ex As Exception
                    WriteLine("Failure when trying to increase beyond {0} digits", CDbl(c) * digits)
                    TimeStamp("error")
                    Stop
                End Try
            End If
        End If
    End Sub

    Sub TimeStamp(cause As String)
        With DateTime.Now - st
            WriteLine("Terminated by {5} at {0} days, {1} hours, {2} minutes, {3}.{4} seconds",
                      .Days, .Hours, .Minutes, .Seconds, .Milliseconds, cause)
        End With
    End Sub

    Sub Main(args As String())
        digits = Long.MaxValue.ToString.Length - 1
        base = CLng(Math.Pow(10, digits)) : b1 = base - 1
        base = 10 : b1 = 9
        sf = "{" & base.ToString.Replace("1", "0:") & "}"
        st = DateTime.Now
        While Not KeyAvailable
            Increment(c) : Write(ar.First)
            For Each item In ar.Skip(1) : Write(sf, item) : Next : WriteLine()
        End While
        TimeStamp("keypress")
    End Sub
End Module
