' Mian-Chowla sequence - VBScript - 15/03/2019
    Const m = 100, mm=28000
    ReDim r(mm), v(mm * 2)
    Dim n, t, i, j, l, s1, s2, iterate_t
    ReDim seq(m)
    t0=Timer
    s1 = "1": s2 = ""
    seq(1) = 1: n = 1: t = 1
    Do While n < m
        t = t + 1
        iterate_t = False
        For i = 1 to t * 2
            v(i) = 0
        Next
        i = 1
        Do While i <= t And Not iterate_t
            If r(i) = 0 Then
                j = i
                Do While j <= t And Not iterate_t
                    If r(j) = 0 Then
                        l = i + j
                        If v(l) = 1 Then
                            r(t) = 1
                            iterate_t = True
                        End If
                        If Not iterate_t Then v(l) = 1
                    End If
                    j = j + 1
                Loop
            End If
            i = i + 1
        Loop
        If Not iterate_t Then
            n = n + 1
            seq(n) = t
            if           n<= 30 then s1 = s1 & " " & t
            if n>=91 and n<=100 then s2 = s2 & " " & t
        End If
    Loop
    wscript.echo "t="& t
    wscript.echo "The Mian-Chowla sequence for elements 1 to 30:"
    wscript.echo s1
    wscript.echo "The Mian-Chowla sequence for elements 91 to 100:"
    wscript.echo s2
    wscript.echo "Computation time: "&  Int(Timer-t0) &" sec"
