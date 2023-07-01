Public Sub circles()
    tests = [{0.1234, 0.9876, 0.8765, 0.2345, 2.0; 0.0000, 2.0000, 0.0000, 0.0000, 1.0; 0.1234, 0.9876, 0.1234, 0.9876, 2.0; 0.1234, 0.9876, 0.8765, 0.2345, 0.5; 0.1234, 0.9876, 0.1234, 0.9876, 0.0}]
    For i = 1 To UBound(tests)
        x1 = tests(i, 1)
        y1 = tests(i, 2)
        x2 = tests(i, 3)
        y2 = tests(i, 4)
        R = tests(i, 5)
        xd = x2 - x1
        yd = y1 - y2
        s2 = xd * xd + yd * yd
        sep = Sqr(s2)
        xh = (x1 + x2) / 2
        yh = (y1 + y2) / 2
        Dim txt As String
        If sep = 0 Then
            txt = "same points/" & IIf(R = 0, "radius is zero", "infinite solutions")
        Else
            If sep = 2 * R Then
                txt = "opposite ends of diameter with centre " & xh & ", " & yh & "."
            Else
                If sep > 2 * R Then
                    txt = "too far apart " & sep & " > " & 2 * R
                Else
                    md = Sqr(R * R - s2 / 4)
                    xs = md * xd / sep
                    ys = md * yd / sep
                    txt = "{" & Format(xh + ys, "0.0000") & ", " & Format(yh + xs, "0.0000") & _
                    "} and {" & Format(xh - ys, "0.0000") & ", " & Format(yh - xs, "0.0000") & "}"
                End If
            End If
        End If
        Debug.Print "points " & "{" & x1 & ", " & y1 & "}" & ", " & "{" & x2 & ", " & y2 & "}" & " with radius " & R & " ==> " & txt
    Next i
End Sub
