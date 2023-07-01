Imports System.Console
Imports DT = System.DateTime
Imports Lsb = System.Collections.Generic.List(Of SByte)
Imports Lst = System.Collections.Generic.List(Of System.Collections.Generic.List(Of SByte))
Imports UI = System.UInt64

Module Module1
    Const MxD As SByte = 15

    Public Structure term
        Public coeff As UI : Public a, b As SByte
        Public Sub New(ByVal c As UI, ByVal a_ As Integer, ByVal b_ As Integer)
            coeff = c : a = CSByte(a_) : b = CSByte(b_)
        End Sub
    End Structure

    Dim nd, nd2, count As Integer, digs, cnd, di As Integer()
    Dim res As List(Of UI), st As DT, tLst As List(Of List(Of term))
    Dim lists As List(Of Lst), fml, dmd As Dictionary(Of Integer, Lst)
    Dim dl, zl, el, ol, il As Lsb, odd As Boolean, ixs, dis As Lst, Dif As UI

    ' converts digs array to the "difference"
    Function ToDif() As UI
        Dim r As UI = 0 : For i As Integer = 0 To digs.Length - 1 : r = r * 10 + digs(i)
        Next : Return r
    End Function

    ' converts digs array to the "sum"
    Function ToSum() As UI
        Dim r As UI = 0 : For i As Integer = digs.Length - 1 To 0 Step -1 : r = r * 10 + digs(i)
        Next : Return Dif + (r << 1)
    End Function

    '  determines if the nmbr is square or not
    Function IsSquare(nmbr As UI) As Boolean
        If (&H202021202030213 And (1UL << (nmbr And 63))) <> 0 Then _
            Dim r As UI = Math.Sqrt(nmbr) : Return r * r = nmbr Else Return False
    End Function

    '// returns sequence of SBbytes
    Function Seq(from As SByte, upto As Integer, Optional stp As SByte = 1) As Lsb
        Dim res As Lsb = New Lsb()
        For item As SByte = from To upto Step stp : res.Add(item) : Next : Return res
    End Function

    ' Recursive closure to generate (n+r) candidates from (n-r) candidates
    Sub Fnpr(ByVal lev As Integer)
        If lev = dis.Count Then
            digs(ixs(0)(0)) = fml(cnd(0))(di(0))(0) : digs(ixs(0)(1)) = fml(cnd(0))(di(0))(1)
            Dim le As Integer = di.Length, i As Integer = 1
            If odd Then le -= 1 : digs(nd >> 1) = di(le)
            For Each d As SByte In di.Skip(1).Take(le - 1)
                digs(ixs(i)(0)) = dmd(cnd(i))(d)(0)
                digs(ixs(i)(1)) = dmd(cnd(i))(d)(1) : i += 1 : Next
            If Not IsSquare(ToSum()) Then Return
            res.Add(ToDif()) : count += 1
            WriteLine("{0,16:n0}{1,4}   ({2:n0})", (DT.Now - st).TotalMilliseconds, count, res.Last())
        Else
            For Each n In dis(lev) : di(lev) = n : Fnpr(lev + 1) : Next
        End If
    End Sub

    ' Recursive closure to generate (n-r) candidates with a given number of digits.
    Sub Fnmr(ByVal list As Lst, ByVal lev As Integer)
        If lev = list.Count Then
            Dif = 0 : Dim i As SByte = 0 : For Each t In tLst(nd2)
                If cnd(i) < 0 Then Dif -= t.coeff * CULng(-cnd(i)) _
                              Else Dif += t.coeff * CULng(cnd(i))
                i += 1 : Next
            If Dif <= 0 OrElse Not IsSquare(Dif) Then Return
            dis = New Lst From {Seq(0, fml(cnd(0)).Count - 1)}
            For Each i In cnd.Skip(1) : dis.Add(Seq(0, dmd(i).Count - 1)) : Next
            If odd Then dis.Add(il)
            di = New Integer(dis.Count - 1) {} : Fnpr(0)
        Else
            For Each n As SByte In list(lev) : cnd(lev) = n : Fnmr(list, lev + 1) : Next
        End If
    End Sub

    Sub init()
        Dim pow As UI = 1
        ' terms of (n-r) expression for number of digits from 2 to maxDigits
        tLst = New List(Of List(Of term))() : For Each r As Integer In Seq(2, MxD)
            Dim terms As List(Of term) = New List(Of term)()
            pow *= 10 : Dim p1 As UI = pow, p2 As UI = 1
            Dim i1 As Integer = 0, i2 As Integer = r - 1
            While i1 < i2 : terms.Add(New term(p1 - p2, i1, i2))
                p1 = p1 / 10 : p2 = p2 * 10 : i1 += 1 : i2 -= 1 : End While
            tLst.Add(terms) : Next
        ' map of first minus last digits for 'n' to pairs giving this value
        fml = New Dictionary(Of Integer, Lst)() From {
            {0, New Lst() From {New Lsb() From {2, 2}, New Lsb() From {8, 8}}},
            {1, New Lst() From {New Lsb() From {6, 5}, New Lsb() From {8, 7}}},
            {4, New Lst() From {New Lsb() From {4, 0}}},
            {6, New Lst() From {New Lsb() From {6, 0}, New Lsb() From {8, 2}}}}
        ' map of other digit differences for 'n' to pairs giving this value
        dmd = New Dictionary(Of Integer, Lst)()
        For i As SByte = 0 To 10 - 1 : Dim j As SByte = 0, d As SByte = i
            While j < 10 : If dmd.ContainsKey(d) Then dmd(d).Add(New Lsb From {i, j}) _
                Else dmd(d) = New Lst From {New Lsb From {i, j}}
                j += 1 : d -= 1 : End While : Next
        dl = Seq(-9, 9)    ' all  differences
        zl = Seq(0, 0)     ' zero difference
        el = Seq(-8, 8, 2) ' even differences
        ol = Seq(-9, 9, 2) ' odd  differences
        il = Seq(0, 9)
        lists = New List(Of Lst)()
        For Each f As SByte In fml.Keys : lists.Add(New Lst From {New Lsb From {f}}) : Next
    End Sub

    Sub Main(ByVal args As String())
        init() : res = New List(Of UI)() : st = DT.Now : count = 0
        WriteLine("{0,5}{1,12}{2,4}{3,14}", "digs", "elapsed(ms)", "R/N", "Rare Numbers")
        nd = 2 : nd2 = 0 : odd = False : While nd <= MxD
            digs = New Integer(nd - 1) {} : If nd = 4 Then
                lists(0).Add(zl) : lists(1).Add(ol) : lists(2).Add(el) : lists(3).Add(ol)
            ElseIf tLst(nd2).Count > lists(0).Count Then
                For Each list As Lst In lists : list.Add(dl) : Next : End If
            ixs = New Lst() : For Each t As term In tLst(nd2) : ixs.Add(New Lsb From {t.a, t.b}) : Next
            For Each list As Lst In lists : cnd = New Integer(list.Count - 1) {} : Fnmr(list, 0) : Next
            WriteLine("  {0,2}  {1,10:n0}", nd, (DT.Now - st).TotalMilliseconds)
            nd += 1 : nd2 += 1 : odd = Not odd : End While
        res.Sort() : WriteLine(vbLf & "The {0} rare numbers with up to {1} digits are:", res.Count, MxD)
        count = 0 : For Each rare In res : count += 1 : WriteLine("{0,2}:{1,27:n0}", count, rare) : Next
        If System.Diagnostics.Debugger.IsAttached Then ReadKey()
    End Sub
End Module
