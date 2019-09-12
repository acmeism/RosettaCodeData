Imports System
Imports System.Numerics
Imports System.Text

Module Module1
    Sub Main()
        Dim n As BigInteger = BigInteger.Parse("9516311845790656153499716760847001433441357")
        Dim e As BigInteger = 65537
        Dim d As BigInteger = BigInteger.Parse("5617843187844953170308463622230283376298685")
        Dim plainTextStr As String = "Hello, Rosetta!"
        Dim plainTextBA As Byte() = ASCIIEncoding.ASCII.GetBytes(plainTextStr)
        Dim pt As BigInteger = New BigInteger(plainTextBA)
        If pt > n Then Throw New Exception() ' Blocking not implemented
        Dim ct As BigInteger = BigInteger.ModPow(pt, e, n)
        Console.WriteLine(" Encoded: " & ct.ToString("X"))
        Dim dc As BigInteger = BigInteger.ModPow(ct, d, n)
        Console.WriteLine(" Decoded: " & dc.ToString("X"))
        Dim decoded As String = ASCIIEncoding.ASCII.GetString(dc.ToByteArray())
        Console.WriteLine("As ASCII: " & decoded)
    End Sub
End Module
