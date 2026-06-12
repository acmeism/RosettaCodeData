Imports System.Linq
Imports System.Collections.Generic
Imports System.Console
Imports System.Math

Module Module1
    Dim ba As Integer
    Dim chars As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    Iterator Function Primes(ByVal lim As Integer) As IEnumerable(Of Integer)
        Dim flags(lim) As Boolean, j As Integer : Yield 2
        For j = 4 To lim Step 2 : flags(j) = True : Next : j = 3
        Dim d As Integer = 8, sq As Integer = 9
        While sq <= lim
            If Not flags(j) Then
                Yield j : Dim i As Integer = j << 1
                For k As Integer = sq To lim step i : flags(k) = True : Next
            End If
            j += 2 : d += 8 : sq += d : End While
        While j <= lim
            If Not flags(j) Then Yield j
            j += 2 : End While
    End Function

    ' convert an int into a string using the current ba
    Function from10(ByVal b As Integer) As String
        Dim res As String = "", re As Integer
        While b > 0 : b = DivRem(b, ba, re) : res = chars(CByte(re)) & res : End While : Return res
    End Function

    ' parse a string into an int, using current ba (not used here)
    Function to10(ByVal s As String) As Integer
        Dim res As Integer = 0
        For Each i As Char In s : res = res * ba + chars.IndexOf(i) : Next : Return res
    End Function

    ' note: comparing the index of the chars instead of the chars themsleves, which avoids case issues
    Function nd(ByVal s As String) As Boolean
        If s.Length < 2 Then Return True
        Dim l As Char = s(0)
        For i As Integer = 1 To s.Length - 1
            If chars.IndexOf(l) > chars.IndexOf(s(i)) Then Return False Else l = s(i)
        Next : Return True
    End Function

    Sub Main(ByVal args As String())
        Dim c As Integer, lim As Integer = 1000, s As String
        For Each b As Integer In New List(Of Integer) From { 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 27, 31, 62 }
            ba = b : c = 0 : For Each a As Integer In Primes(lim)
                s = from10(a) : If nd(s) Then c += 1 : Write("{0,4} {1}", s, If(c Mod 20 = 0, vbLf, ""))
            Next
            WriteLine(vbLf & "Base {0}: found {1} non-decreasing primes under {2:n0}" & vbLf, b, c, from10(lim))
        Next
    End Sub
End Module
