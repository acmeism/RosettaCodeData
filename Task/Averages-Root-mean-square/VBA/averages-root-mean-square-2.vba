Function rms(iLow As Integer, iHigh As Integer)
    Dim i As Integer
    If iLow > iHigh Then
        i = iLow
        iLow = iHigh
        iHigh = i
    End If
    For i = iLow To iHigh
        rms = rms + i ^ 2
    Next i
    rms = Sqr(rms / (iHigh - iLow + 1))
End Function

Sub foo()
    Debug.Print rms(1, 10)
End Sub
