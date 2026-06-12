Imports System
Imports System.Console
Imports LI = System.Collections.Generic.SortedSet(Of Integer)

Module Module1
    Function unl(ByVal res As LI, ByVal lst As LI, ByVal lft As Integer, ByVal Optional mul As Integer = 1, ByVal Optional vlu As Integer = 0) As LI
        If lft = 0 Then
            res.Add(vlu)
        ElseIf lft > 0 Then
            For Each itm As Integer In lst
                res = unl(res, lst, lft - itm, mul * 10, vlu + itm * mul)
            Next
        End If
        Return res
    End Function

    Sub Main(ByVal args As String())
        WriteLine(string.Join(" ",
            unl(new LI From {}, new LI From { 2, 3, 5, 7 }, 13)))
    End Sub
End Module
