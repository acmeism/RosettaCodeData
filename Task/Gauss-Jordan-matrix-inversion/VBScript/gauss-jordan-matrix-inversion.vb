' Gauss-Jordan matrix inversion - VBScript - 22/01/2021
Option Explicit

Function rref(m)
    Dim r, c, i, n, div, wrk
    n=UBound(m)
    For r = 1 To n  'row
        div = m(r,r)
        If div <> 0 Then
            For c = 1 To n*2  'col
                m(r,c) = m(r,c) / div
            Next 'c
        Else
            WScript.Echo "inversion impossible!"
            WScript.Quit
        End If
        For i = 1 To n  'row
            If i <> r Then
                wrk = m(i,r)
                For c = 1 To n*2
                    m(i,c) = m(i,c) - wrk * m(r,c)
                Next' c
            End If
        Next 'i
    Next 'r
    rref = m
End Function 'rref

Function inverse(mat)
    Dim i, j, aug, inv, n
    n = UBound(mat)
    ReDim inv(n,n), aug(n,2*n)
    For i = 1 To n
        For j = 1 To n
            aug(i,j) = mat(i,j)
        Next 'j
        aug(i,i+n) = 1
    Next 'i
    aug = rref(aug)
    For i = 1 To n
        For j = n+1 To 2*n
            inv(i,j-n) = aug(i,j)
        Next 'j
    Next 'i
    inverse = inv
End Function 'inverse

Sub wload(m)
    Dim i, j, k
    k = -1
    For i = 1 To n
        For j = 1 To n
            k = k + 1
            m(i,j) = w(k)
        Next 'j
    Next 'i
End Sub 'wload

Sub show(c, m, t)
    Dim i, j, buf
    buf = "Matrix " & c &"=" & vbCrlf & vbCrlf
    For i = 1 To n
        For j = 1 To n
            If t="fixed" Then
                buf = buf & FormatNumber(m(i,j),6,,,0) & "  "
            Else
                buf = buf & m(i,j) & "  "
            End If
        Next 'j
        buf=buf & vbCrlf
    Next 'i
    WScript.Echo buf
End Sub 'show

Dim n, a, b, c, w
w = Array( _
	2,  1,  1,  4, _
	0, -1,  0, -1, _
	1,  0, -2,  4, _
	4,  1,  2,  2)
n=Sqr(UBound(w)+1)
ReDim a(n,n), b(n,n), c(n,n)
wload a
show "a", a, "simple"
b = inverse(a)
show "b", b, "fixed"
c = inverse(b)
show "c", c, "fixed"
