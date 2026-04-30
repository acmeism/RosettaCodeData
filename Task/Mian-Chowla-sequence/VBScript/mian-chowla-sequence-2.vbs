' Mian-Chowla sequence - VBScript - March 19th, 2019

    Function Find(x(), val) ' finds val on a pre-sorted list
        Dim l, u, h : l = 0 : u = ubound(x) : Do : h = (l + u) \ 2
            If val = x(h) Then Find = h : Exit Function
            If val > x(h) Then l = h + 1 Else u = h - 1
        Loop Until l > u : Find = -1
    End Function

    ' adds next item from a() to result (r()), adds all remaining items
    ' from b(), once a() is exhausted
    Sub Shuffle(ByRef r(), a(), b(), ByRef i, ByRef ai, ByRef bi, al, bl)
        r(i) = a(ai) : ai = ai + 1 : If ai > al Then Do : i = i + 1 : _
            r(i) = b(bi) : bi = bi + 1 : Loop until bi = bl
    End Sub

    Function Merger(a(), b(), bl) ' merges two pre-sorted lists
        Dim res(), ai, bi, i : ReDim res(ubound(a) + bl) : ai = 0 : bi = 0
        For i = 0 To ubound(res)
            If a(ai) < b(bi) Then Shuffle res, a, b, i, ai, bi, ubound(a), bl _
            Else Shuffle res, b, a, i, bi, ai, bl, ubound(a)
        Next : Merger = res
    End Function

    Const n = 100 : Dim mc(), sums(), ts(), sp, tc : sp = 1 : tc = 0
    ReDim mc(n - 1), sums(0), ts(n - 1) : mc(0) = 1 : sums(sp - 1) = 2
    Dim sum, i, j, k, st : st = Timer
    wscript.echo "The Mian-Chowla sequence for elements 1 to 30:"
    wscript.stdout.write("1 ")
    For i = 1 To n - 1 : j = mc(i - 1) + 1 : Do
            mc(i) = j : For k = 0 To i
                sum = mc(k) + j : If Find(sums, sum) >= 0 Then _
                    tc = 0 : Exit For Else ts(tc) = sum : tc = tc + 1
            Next : If tc > 0 Then
              nu = Merger(sums, ts, tc) : ReDim sums(ubound(nu))
              For e = 0 To ubound(nu) : sums(e) = nu(e) : Next
              tc = 0 : Exit Do
            End If : j = j + 1 : Loop
        if i = 90 then wscript.echo vblf & vbLf & _
            "The Mian-Chowla sequence for elements 91 to 100:"
        If i < 30 or i >= 90 Then wscript.stdout.write(mc(i) & " ")
    Next
    wscript.echo vblf & vbLf & "Computation time: "& Timer - st &" seconds."
