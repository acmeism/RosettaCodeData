Option Strict On
Option Explicit On

Imports System.IO

Module vMain

    Public Sub Main
        Dim s As Integer() = New Integer(){1, 2, 2, 3, 4, 4, 5}
        For i As Integer = 0 To Ubound(s)
            Dim curr As Integer = s(i)
            Dim prev As Integer
            If i > 1 AndAlso curr = prev Then
                  Console.Out.WriteLine(i)
            End If
            prev = curr
        Next i
    End Sub

End Module
