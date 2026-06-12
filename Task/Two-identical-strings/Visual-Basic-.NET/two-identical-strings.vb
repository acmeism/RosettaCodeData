Imports System.Console
Module Module1
  Sub Main()
    Dim p, c, k, lmt as integer : p = 2 : lmt = 1000
    For n As Integer = 1 to lmt
      p += If(n >= p, p, 0) : k = n + n * p
      If k > lmt Then Exit For Else c += 1
      Write("{0,3} ({1,-10})  {2}", k, Convert.ToString( k, 2),
          If(c Mod 5 = 0, vbLf, ""))
    Next : WriteLine(vbLf + "Found {0} numbers whose base 2 representation is the concatenation of two identical binary strings.", c)
  End Sub
End Module
