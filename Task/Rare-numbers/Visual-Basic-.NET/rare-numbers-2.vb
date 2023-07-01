Imports System.Math
Imports System.Console
Imports llst = System.Collections.Generic.List(Of Integer())

Module Module1
    Dim d, dac As Integer(), drar As Integer() = New Integer(19) {} : Dim ac, pp As Long(), p As Long() = New Long(18) {}
    Dim odd As Boolean = False : Dim sum, rt As Long : Dim ln, dl As Integer, cn As Integer = 0, nd As Integer = 2, nd1 As Integer = nd - 1
    Dim sw As Stopwatch = New Stopwatch(), swt As Stopwatch = New Stopwatch() : Dim sr As List(Of Long) = New List(Of Long)()
    ReadOnly tlo As Integer() = New Integer() {0, 1, 4, 5, 6}, all As Integer() = Seq(-9, 9), odl As Integer() = Seq(-9, 9, 2), evl As Integer() = Seq(-8, 8, 2),
        thi As Integer() = New Integer() {4, 5, 6, 9, 10, 11, 14, 15, 16}, alh As Integer() = Seq(0, 18), odh As Integer() = Seq(1, 17, 2),
        evh As Integer() = Seq(0, 18, 2), ten As Integer() = Seq(0, 9), z As Integer() = Seq(0, 0), t7 As Integer() = New Integer() {-3, 7}, nin As Integer() = New Integer() {9}, tn As Integer() = New Integer() {10}, t12 As Integer() = New Integer() {2, 12}, o11 As Integer() = New Integer() {1, 11}, pos As Integer() = New Integer() {0, 1, 4, 5, 6, 9}
    Dim lu, l2 As llst, lul As llst = New llst From {z, odl, Nothing, Nothing, evl, t7, odl},
        luh As llst = New llst From {tn, evh, Nothing, Nothing, evh, t12, odh, Nothing, Nothing, evh, nin, odh, Nothing, Nothing, odh, o11, evh},
        l2l As llst = New llst From {pos, Nothing, Nothing, Nothing, all, Nothing, all},
        l2h As llst = New llst From {Nothing, Nothing, Nothing, Nothing, alh, Nothing, alh, Nothing, Nothing, Nothing, alh, Nothing, Nothing, Nothing, alh, Nothing, alh}
    Dim chTen As Integer()() = New Integer()() {New Integer() {0, 2, 5, 8, 9}, New Integer() {0, 3, 4, 6, 9}, New Integer() {1, 4, 7, 8},
                                                New Integer() {2, 3, 5, 8}, New Integer() {0, 3, 6, 7, 9}, New Integer() {1, 2, 4, 7},
                                                New Integer() {2, 5, 6, 8}, New Integer() {0, 1, 3, 6, 9}, New Integer() {1, 4, 5, 7}}
    Dim chAH As Integer()() = New Integer()() {
        New Integer() {0, 2, 5, 8, 9, 11, 14, 17, 18}, New Integer() {0, 3, 4, 6, 9, 12, 13, 15, 18}, New Integer() {1, 4, 7, 8, 10, 13, 16, 17},
        New Integer() {2, 3, 5, 8, 11, 12, 14, 17}, New Integer() {0, 3, 6, 7, 9, 12, 15, 16, 18}, New Integer() {1, 2, 4, 7, 10, 11, 13, 16},
        New Integer() {2, 5, 6, 8, 11, 14, 15, 17}, New Integer() {0, 1, 3, 6, 9, 10, 12, 15, 18}, New Integer() {1, 4, 5, 7, 10, 13, 14, 16}}

    Function Seq(ByVal f As Integer, ByVal t As Integer, ByVal Optional s As Integer = 1) As Integer()
        Dim r As Integer() = New Integer((t - f) / s + 1 - 1) {}
        For i As Integer = 0 To r.Length - 1 : r(i) = f : f += s : Next : Return r : End Function

    Function ISR(ByVal s As Long) As Long
        Return Sqrt(s) : End Function

    Function IsRev(ByVal nd As Integer, ByVal f As Long, ByVal r As Long) As Boolean
        nd -= 1 : Return If(f \ p(nd) <> r Mod 10, False, (If(nd < 1, True, IsRev(nd, f Mod p(nd), r \ 10)))) : End Function

    Sub RecurseLE5(ByVal lst As llst, ByVal lv As Integer)
        If lv = dl Then
            sum = ac(lv - 1) : If sum > 0 Then rt = CLng(Sqrt(sum)) : If rt * rt = sum Then sr.Add(sum)
        Else For Each n As Integer In lst(lv)
                d(lv) = n : If lv = 0 Then ac(0) = pp(0) * n Else ac(lv) = ac(lv - 1) + pp(lv) * n
                RecurseLE5(lst, lv + 1) : Next : End If : End Sub

    Sub Recursehi(ByVal lst As llst, ByVal lv As Integer)
        Dim lv1 As Integer = lv - 1 : If lv = dl Then
            sum = ac(lv1) : If (&H202021202030213 And (1L << (sum And 63))) > 0 Then rt = CLng(Sqrt(sum)) : If rt * rt = sum Then sr.Add(sum)
        Else For Each n As Integer In lst(lv)
                d(lv) = n : If lv = 0 Then ac(0) = pp(0) * n : dac(0) = drar(n) _
                Else ac(lv) = ac(lv1) + pp(lv) * n : dac(lv) = dac(lv1) + drar(n) : If dac(lv) > 8 Then dac(lv) -= 9
                Select Case lv
                    Case 0 : ln = n : lst(1) = lu(n) : lst(2) = l2(n)
                    Case 1 : Select Case ln
                            Case 5, 15 : lst(2) = If(n < 10, evh, odh)
                            Case 9 : lst(2) = If(((n >> 1) And 1) = 0, evh, odh)
                            Case 11 : lst(2) = If(((n >> 1) And 1) = 1, evh, odh)
                        End Select : End Select
                If lv = dl - 2 Then lst(dl - 1) = If(odd, chTen(dac(dl - 2)), chAH(dac(dl - 2)))
                Recursehi(lst, lv + 1) : Next : End If : End Sub

    Sub Recurselo(ByVal lst As llst, ByVal lv As Integer)
        Dim lv1 As Integer = lv - 1 : If lv = dl Then
            sum = ac(lv1) : If sum > 0 Then rt = CLng(Sqrt(sum)) : If rt * rt = sum Then sr.Add(sum)
        Else For Each n As Integer In lst(lv)
                d(lv) = n : If lv = 0 Then ac(0) = pp(0) * n Else ac(lv) = ac(lv1) + pp(lv) * n
                Select Case lv
                    Case 0 : ln = n : lst(1) = lu(n) : lst(2) = l2(n)
                    Case 1 : Select Case ln
                            Case 1 : lst(2) = If((((n + 9) >> 1) And 1) = 0, evl, odl)
                            Case 5 : lst(2) = If(n < 0, evl, odl)
                        End Select : End Select
                Recurselo(lst, lv + 1) : Next : End If : End Sub

    Function listEm(ByVal lst As llst, ByVal plu As llst, ByVal pl2 As llst) As List(Of Long)
        dl = lst.Count : d = New Integer(dl - 1) {} : sr.Clear() : lu = plu : l2 = pl2
        ac = New Long(dl - 1) {} : dac = New Integer(dl - 1) {} : pp = New Long(dl - 1) {}
        Dim j As Integer = nd1 : For i As Integer = 0 To dl - 1 : pp(i) = If(lst(0).Length > 6, p(j) + p(i), p(j) - p(i)) : j -= 1 : Next
        If nd <= 5 Then RecurseLE5(lst, 0) Else If lst(0).Length > 6 Then Recursehi(lst, 0) Else Recurselo(lst, 0)
        Return sr : End Function

    Sub Reveal(ByVal lo As List(Of Long), ByVal hi As List(Of Long))
        Dim s As List(Of String) = New List(Of String)() : For Each l As Long In lo : For Each h As Long In hi
                Dim r As Long = (h - l) \ 2, f As Long = h - r
                If IsRev(nd, f, r) Then s.Add(String.Format("{0,20} {1,11} {2,10}  ", f, ISR(h), ISR(l)))
            Next : Next : s.Sort() : If s.Count > 0 Then _
            For Each t As String In s : cn += 1 : Write("{0,2} {1}{2}", cn, t, If(t = s.Last(), "", vbLf)) : Next Else Write("{0,48}", "")
    End Sub

    Sub Main(ByVal args As String())
        WriteLine("{0,3}{1,20} {2,11} {3,10}  {4,4}{5,16} {6, 17}", "nth", "forward", "rt.sum", "rt.dif", "digs", "block time", "total time")
        p(0) = 1 : Dim j As Integer = 0 : For i As Integer = 1 To p.Length - 1 : p(i) = p(j) * 10 : j = i : Next
        For i As Integer = 0 To drar.Length - 1 : drar(i) = (i * 2) Mod 9 : Next
        Dim lls As llst = New llst From {tlo}, hls As llst = New llst From {thi} : sw.Start() : swt.Start()
        While nd <= 18
            If nd > 2 Then If odd Then hls.Add(ten) Else lls.Add(all) : hls(hls.Count - 1) = alh
            Reveal(listEm(lls, lul, l2l).ToList(), listEm(hls, luh, l2h))
            If Not odd AndAlso nd > 5 Then hls(hls.Count - 1) = alh
            WriteLine("{0,2}: {1}  {2}", nd, sw.Elapsed, swt.Elapsed) : sw.Restart()
            nd1 = nd : nd += 1 : odd = Not odd
        End While
        ' 19
        hls.Add(ten)
        Reveal(listEmU(lls, lul, l2l).ToList(), listEmU(hls, luh, l2h))
        WriteLine("{0,2}: {1}  {2}", nd, sw.Elapsed, swt.Elapsed) : End Sub
#Region "19"
    Dim usum, urt As ULong
    Dim acu, ppu As ULong()
    Dim sru As List(Of ULong) = New List(Of ULong)()

    Sub Reveal(ByVal lo As List(Of ULong), ByVal hi As List(Of ULong))
        Dim s As List(Of String) = New List(Of String)() : For Each l As ULong In lo : For Each h As ULong In hi
                Dim r As ULong = (h - l) >> 1, f As ULong = h - r
                If IsRev(nd, f, r) Then s.Add(String.Format("{0,20} {1,11} {2,10}  ", f, ISR(h), ISR(l)))
            Next : Next : s.Sort() : If s.Count > 0 Then _
            For Each t As String In s : cn += 1 : Write("{0,2} {1}{2}", cn, t, If(t = s.Last(), "", vbLf)) : Next Else Write("{0,48}", "")
    End Sub

    Function listEmU(ByVal lst As llst, ByVal plu As llst, ByVal pl2 As llst) As List(Of ULong)
        dl = lst.Count : d = New Integer(dl - 1) {} : sru.Clear() : lu = plu : l2 = pl2
        acu = New ULong(dl - 1) {} : dac = New Integer(dl - 1) {} : ppu = New ULong(dl - 1) {}
        Dim j As Integer = nd1 : For i As Integer = 0 To dl - 1 : ppu(i) = CULng(If(lst(0).Length > 6, p(j) + p(i), p(j) - p(i))) : j -= 1 : Next
        If lst(0).Length > 8 Then RecurseUhi(lst, 0) Else RecurseUlo(lst, 0)
        Return sru : End Function

    Sub RecurseUhi(ByVal lst As llst, ByVal lv As Integer)
        Dim lv1 As Integer = lv - 1 : If lv = dl Then
            usum = acu(lv1)
            If (&H202021202030213 And (1UL << (usum And 63))) <> 0 Then urt = Sqrt(usum) : If urt * urt = usum Then sru.Add(usum)
        Else For Each n As Integer In lst(lv)
                d(lv) = n : If lv = 0 Then
                    acu(0) = ppu(0) * CUInt(n) : dac(0) = drar(n)
                Else
                    acu(lv) = If(n >= 0, acu(lv1) + ppu(lv) * CUInt(n), acu(lv1) - ppu(lv) * CUInt(-n))
                    dac(lv) = dac(lv1) + drar(n) : If dac(lv) > 8 Then dac(lv) -= 9
                End If
                Select Case lv
                    Case 0 : ln = n : lst(1) = lu(n) : lst(2) = l2(n)
                    Case 1 : Select Case ln
                            Case 5, 15 : lst(2) = If(n < 10, evh, odh)
                            Case 9 : lst(2) = If(((n >> 1) And 1) = 0, evh, odh)
                            Case 11 : lst(2) = If(((n >> 1) And 1) = 1, evh, odh)
                        End Select : End Select
                If lv = dl - 2 Then lst(dl - 1) = If(odd, chTen(dac(dl - 2)), chAH(dac(dl - 2)))
                RecurseUhi(lst, lv + 1) : Next : End If : End Sub

    Sub RecurseUlo(ByVal lst As llst, ByVal lv As Integer)
        Dim lv1 As Integer = lv - 1 : If lv = dl Then
            usum = acu(lv1)
            If usum > 0 Then urt = Sqrt(usum) : If urt * urt = usum Then sru.Add(usum)
        Else For Each n As Integer In lst(lv)
                d(lv) = n : If lv = 0 Then acu(0) = ppu(0) * CUInt(n) Else _
                    acu(lv) = If(n >= 0, acu(lv1) + ppu(lv) * CUInt(n), acu(lv1) - ppu(lv) * CUInt(-n))
                Select Case lv
                    Case 0 : ln = n : lst(1) = lu(n) : lst(2) = l2(n)
                    Case 1 : Select Case ln
                            Case 1 : lst(2) = If((((n + 9) >> 1) And 1) = 0, evl, odl)
                            Case 5 : lst(2) = If(n < 0, evl, odl)
                        End Select : End Select
                RecurseUlo(lst, lv + 1) : Next : End If : End Sub

    Function ISR(ByVal s As ULong) As ULong
        Return Sqrt(s) : End Function

    Function IsRev(ByVal nd As Integer, ByVal f As ULong, ByVal r As ULong) As Boolean
        nd -= 1 : Return If(f \ CULng(p(nd)) <> r Mod 10, False, (If(nd < 1, True, IsRev(nd, f Mod CULng(p(nd)), r \ 10UL)))) : End Function
#End Region
End Module
