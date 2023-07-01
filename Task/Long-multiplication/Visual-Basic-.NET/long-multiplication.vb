Imports System
Imports System.Console
Imports BI = System.Numerics.BigInteger

Module Module1

    Dim a As Decimal, mx As Decimal = 1E28D, hm As Decimal = 1E14D

    ' allows for 56 digit representation, using 28 decimal digits from each decimal
    Structure bd
        Public hi, lo As Decimal
    End Structure

    ' outputs bd structure as string, optionally inserting commas
    Function toStr(ByVal a As bd, ByVal Optional comma As Boolean = False) As String
        Dim r As String = If(a.hi = 0, String.Format("{0:0}", a.lo),
                                       String.Format("{0:0}{1:" & New String("0"c, 28) & "}", a.hi, a.lo))
        If Not comma Then Return r
        Dim rc As String = ""
        For i As Integer = r.Length - 3 To 0 Step -3
            rc = "," & r.Substring(i, 3) & rc : Next
        toStr = r.Substring(0, r.Length Mod 3) & rc
            toStr = toStr.Substring(If(toStr.Chars(0) = "," , 1, 0))
    End Function

    ' needed because Math.Pow() returns a double
    Function Pow_dec(ByVal bas As Decimal, ByVal exp As UInteger) As Decimal
        If exp = 0 Then Pow_dec = 1D else Pow_dec = Pow_dec(bas, exp >> 1) : _
        Pow_dec *= Pow_dec : If (exp And 1) <> 0 Then Pow_dec *= bas
    End Function

    Sub Main(ByVal args As String())
         For p As UInteger = 64 To 95 - 1 Step 30                 ' show prescribed output and maximum power of 2 output
            Dim y As bd, x As bd : a = Pow_dec(2D, p)             ' init the bd variables, a = decimal value to be squared
            WriteLine("The square of (2^{0}):                    {1,38:n0}", p, a)
            x.hi = Math.Floor(a / hm) : x.lo = a Mod hm           ' setup for the squaring process
            Dim BS As BI = BI.Pow(CType(a, BI), 2)                ' for the BigInteger checking of result
            y.lo = x.lo * x.lo : y.hi = x.hi * x.hi               ' square the lo and the hi parts
            a = x.hi * x.lo * 2D                                  ' calculate the middle term (mid-term)
            y.hi += Math.Floor(a / hm) : y.lo += (a Mod hm) * hm  ' increment hi and lo parts with high and low parts of the mid-term
            While y.lo > mx : y.lo -= mx : y.hi += 1 : End While  ' check for overflow, adjust both parts as needed
            WriteLine(" is {0,75} (which {1} match the BigInteger computation)" & vbLf,
                toStr(y, True), If(BS.ToString() = toStr(y), "does", "fails to"))
        Next
    End Sub

End Module
