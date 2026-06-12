Imports System.Collections.Generic, System.Linq, System.Console

Module Module1
    Function soas(ByVal n As Integer, ByVal f As IEnumerable(Of Integer)) As Boolean
        If n <= 0 Then Return False Else If f.Contains(n) Then Return True
        Select Case n.CompareTo(f.Sum())
            Case 1 : Return False : Case 0 : Return True
            Case -1 : Dim rf As List(Of Integer) = f.Reverse().ToList() : Dim D as Integer = n - rf(0)
                rf.RemoveAt(0) : Return soas(d, rf) OrElse soas(n, rf)
        End Select : Return true
    End Function

    Function ip(ByVal n As Integer) As Boolean
        Dim f As IEnumerable(Of Integer) = Enumerable.Range(1, n >> 1).Where(Function(d) n Mod d = 0).ToList()
        Return Enumerable.Range(1, n - 1).ToList().TrueForAll(Function(i) soas(i, f))
    End Function

    Sub Main()
        Dim c As Integer = 0, m As Integer = 333, i As Integer = 1 : While i <= m
            If ip(i) OrElse i = 1 Then c += 1 : Write("{0,3} {1}", i, If(c Mod 10 = 0, vbLf, ""))
            i += If(i = 1, 1, 2) : End While
        Write(vbLf & "Found {0} practical numbers between 1 and {1} inclusive." & vbLf, c, m)
        Do : m = If(m < 500, m << 1, m * 10 + 6)
            Write(vbLf & "{0,5} is a{1}practical number.", m, If(ip(m), " ", "n im")) : Loop While m < 1e4
    End Sub
End Module
