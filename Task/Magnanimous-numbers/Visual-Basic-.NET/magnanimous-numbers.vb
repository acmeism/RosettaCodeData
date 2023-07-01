Imports System, System.Console

Module Module1

    Dim np As Boolean()

    Sub ms(ByVal lmt As Long)
        np = New Boolean(CInt(lmt)) {} : np(0) = True : np(1) = True
        Dim n As Integer = 2, j As Integer = 1 : While n < lmt
            If Not np(n) Then
                Dim k As Long = CLng(n) * n
                While k < lmt : np(CInt(k)) = True : k += n : End While
            End If : n += j : j = 2 : End While
    End Sub

    Function is_Mag(ByVal n As Integer) As Boolean
        Dim res, rm As Integer, p As Integer = 10
        While n >= p
            res = Math.DivRem(n, p, rm)
            If np(res + rm) Then Return False
            p = p * 10 : End While : Return True
    End Function

    Sub Main(ByVal args As String())
        ms(100_009) : Dim mn As String = " magnanimous numbers:"
        WriteLine("First 45{0}", mn) : Dim l As Integer = 0, c As Integer = 0
        While c < 400 : If is_Mag(l) Then
            c += 1 : If c <= 45 OrElse (c > 240 AndAlso c <= 250) OrElse c > 390 Then Write(If(c <= 45, "{0,4} ", "{0,8:n0} "), l)
            If c < 45 AndAlso c Mod 15 = 0 Then WriteLine()
            If c = 240 Then WriteLine(vbLf & vbLf & "241st through 250th{0}", mn)
            If c = 390 Then WriteLine(vbLf & vbLf & "391st through 400th{0}", mn)
        End If : l += 1 : End While
    End Sub
End Module
