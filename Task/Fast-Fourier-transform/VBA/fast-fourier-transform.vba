Option Base 0

Private Type Complex
    re As Double
    im As Double
End Type

Private Function cmul(c1 As Complex, c2 As Complex) As Complex
Dim ret As Complex
    ret.re = c1.re * c2.re - c1.im * c2.im
    ret.im = c1.re * c2.im + c1.im * c2.re
    cmul = ret
End Function

Public Sub FFT(buf() As Complex, out() As Complex, begin As Integer, step As Integer, N As Integer)
Dim i As Integer, t As Complex, c As Complex, v As Complex
    If step < N Then
        FFT out, buf, begin, 2 * step, N
        FFT out, buf, begin + step, 2 * step, N

        i = 0
        While i < N
            t.re = Cos(-WorksheetFunction.Pi() * i / N)
            t.im = Sin(-WorksheetFunction.Pi() * i / N)
            c = cmul(t, out(begin + i + step))
            buf(begin + (i \ 2)).re = out(begin + i).re + c.re
            buf(begin + (i \ 2)).im = out(begin + i).im + c.im
            buf(begin + ((i + N) \ 2)).re = out(begin + i).re - c.re
            buf(begin + ((i + N) \ 2)).im = out(begin + i).im - c.im
            i = i + 2 * step
        Wend
    End If
End Sub

' --- test routines:

Private Sub show(r As Long, txt As String, buf() As Complex)
Dim i As Integer
    r = r + 1
    Cells(r, 1) = txt
    For i = LBound(buf) To UBound(buf)
        r = r + 1
        Cells(r, 1) = buf(i).re: Cells(r, 2) = buf(i).im
    Next
End Sub

Sub testFFT()
Dim buf(7) As Complex, out(7) As Complex
Dim r As Long, i As Integer
    buf(0).re = 1: buf(1).re = 1: buf(2).re = 1: buf(3).re = 1

    r = 0
    show r, "Input (real, imag):", buf
    FFT out, buf, 0, 1, 8
    r = r + 1
    show r, "Output (real, imag):", out
End Sub
