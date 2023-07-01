'Non-continuous subsequences - VBScript - 03/02/2021

Function noncontsubseq(l)
    Dim  i, j, g, n, r, s, w, m
    Dim  a, b, c
    n = Ubound(l)
    For s = 0 To n-2
        For g = s+1 To n-1
            a = "["
            For i = s To g-1
                a = a & l(i) & ", "
            Next 'i
            For w = 1 To n-g
                r = n+1-g-w
                For i = 1 To 2^r-1 Step 2
                    b = a
                    For j = 0 To r-1
                        If i And 2^j Then b=b & l(g+w+j) & ", "
                    Next 'j
                    c = (Left(b, Len(b)-1))
                    WScript.Echo Left(c, Len(c)-1) & "]"
					m = m+1
                Next 'i
            Next 'w
        Next 'g
    Next 's
    noncontsubseq = m
End Function 'noncontsubseq

list = Array("1", "2", "3", "4")
WScript.Echo "List: [" & Join(list, ", ") & "]"
nn = noncontsubseq(list)
WScript.Echo nn & " non-continuous subsequences"
