Imports System.Numerics

Module Program
    Dim base, bm1 As Byte, hs As New HashSet(Of Byte), st0 As DateTime
    Const chars As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|"

    ' converts base10 to string, using current base
    Function toStr(ByVal b As BigInteger) As String
        toStr = "" : Dim re As BigInteger : While b > 0
            b = BigInteger.DivRem(b, base, re) : toStr = chars(CByte(re)) & toStr : End While
    End Function

    ' checks for all digits present, checks every one (use when extra digit is present)
    Function allIn(ByVal b As BigInteger) As Boolean
        Dim re As BigInteger : hs.Clear() : While b > 0 : b = BigInteger.DivRem(b, base, re)
            hs.Add(CByte(re)) : End While : Return hs.Count = base
    End Function

    ' checks for all digits present, bailing when duplicates occur (can't use when extra digit is present)
    Function allInQ(ByVal b As BigInteger) As Boolean
        Dim re As BigInteger, c As Integer = 0 : hs.Clear() : While b > 0 : b = BigInteger.DivRem(b, base, re)
            hs.Add(CByte(re)) : c += 1 : If c <> hs.Count Then Return False
        End While : Return True
    End Function

    ' converts string to base 10, using current base
    Function to10(s As String) As BigInteger
        to10 = 0 : For Each i As Char In s : to10 = to10 * base + chars.IndexOf(i) : Next
    End Function

    ' returns minimum string representation, optionally inserting a digit
    Function fixup(n As Integer) As String
        fixup = chars.Substring(0, base)
        If n > 0 Then fixup = fixup.Insert(n, n.ToString)
        fixup = "10" & fixup.Substring(2)
    End Function

    ' returns close approx.
    Function IntSqRoot(v As BigInteger) As BigInteger
        IntSqRoot = New BigInteger(Math.Sqrt(CDbl(v))) : Dim term As BigInteger
        Do : term = v / IntSqRoot : If BigInteger.Abs(term - IntSqRoot) < 2 Then Exit Do
            IntSqRoot = (IntSqRoot + term) / 2 : Loop Until False
    End Function

    ' tabulates one base
    Sub doOne()
        bm1 = base - 1 : Dim dr As Byte = 0 : If (base And 1) = 1 Then dr = base >> 1
        Dim id As Integer = 0, inc As Integer = 1, i As Long = 0, st As DateTime = DateTime.Now
        Dim sdr(bm1 - 1) As Byte, rc As Byte = 0 : For i = 0 To bm1 - 1 : sdr(i) = (i * i) Mod bm1
            rc += If(sdr(i) = dr, 1, 0) : sdr(i) += If(sdr(i) = 0, bm1, 0) : Next : i = 0
        If dr > 0 Then
            id = base : For i = 1 To dr : If sdr(i) >= dr Then If id > sdr(i) Then id = sdr(i)
            Next : id -= dr : i = 0 : End If
        Dim sq As BigInteger = to10(fixup(id)), rt As BigInteger = IntSqRoot(sq) + 0,
            dn As BigInteger = (rt << 1) + 1, d As BigInteger = 1
        sq = rt * rt : If base > 3 AndAlso rc > 0 Then
            While sq Mod bm1 <> dr : rt += 1 : sq += dn : dn += 2 : End While ' alligns sq to dr
            inc = bm1 \ rc : If inc > 1 Then dn += rt * (inc - 2) - 1 : d = inc * inc
            dn += dn + d
        End If : d <<= 1 : If base > 5 AndAlso rc > 0 Then : Do : If allInQ(sq) Then Exit Do
                sq += dn : dn += d : i += 1 : Loop Until False : Else : Do : If allIn(sq) Then Exit Do
                sq += dn : dn += d : i += 1 : Loop Until False : End If : rt += i * inc
        Console.WriteLine("{0,3} {1,3} {2,2} {3,20} -> {4,-38} {5,10} {6,8:0.000}s   {7,8:0.000}s",
                          base, inc, If(id = 0, " ", id.ToString), toStr(rt), toStr(sq), i,
                          (DateTime.Now - st).TotalSeconds, (DateTime.Now - st0).TotalSeconds)
    End Sub

    Sub Main(args As String())
        st0 = DateTime.Now
        Console.WriteLine("base inc id                root    square" & _
            "                                 test count    time        total")
        For base = 2 To 28 : doOne() : Next
        Console.WriteLine("Elasped time was {0,8:0.00} minutes", (DateTime.Now - st0).TotalMinutes)
    End Sub
End Module
