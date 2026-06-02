Option Strict On
Option Explicit On

Imports System.IO

Module LongestCommonSubsequence

    Public Function LCS(s As String, t As String) As String
        If s = "" Or t = "" Then
            ' Trivial case: empty strings have an empty LCS.
            Return   ""
        ElseIf s(s.Length - 1) = t(t.Length - 1) Then
            ' If the last characters of 's' and 't' match, prepend the LCS of the preceeding strings
            Return LCS(s.Substring(0, s.Length - 1), t.Substring(0, t.Length - 1)) & s(s.Length - 1)
        Else
            ' Find the longest LCS of these cases:
            ' (1) excluding the last character of 's' including the last of 't',
            ' (2) excluding the last character of 't' including the last of 's'.
            Dim u As String = LCS(s.Substring(0, s.Length - 1), t)
            Dim v As String = LCS(s, t.Substring(0, t.Length - 1))
            Return If(u.Length > v.Length, u, v)
        End If
    End Function

    Public Sub Main
        Console.Out.WriteLine(LCS("1234", "1224533324"))
        Console.Out.WriteLine(LCS("thisisatest", "testing123testing"))
    End Sub

End Module
