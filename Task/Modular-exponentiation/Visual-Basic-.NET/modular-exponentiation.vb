' Modular exponentiation - VB.Net - 21/01/2019
    Imports System.Numerics

    Private Sub Main()
        Dim a, b, m, x As BigInteger
        a = BigInteger.Parse("2988348162058574136915891421498819466320163312926952423791023078876139")
        b = BigInteger.Parse("2351399303373464486466122544523690094744975233415544072992656881240319")
        m = BigInteger.Pow(10, 40)   '=10^40
        x = ModPowBig(a, b, m)
        Debug.Print("x=" & x.ToString)
    End Sub 'Main

    Function ModPowBig(ByVal base As BigInteger, ByVal exponent As BigInteger, ByVal modulus As BigInteger) As BigInteger
        Dim result As BigInteger
        result = 1
        Do While exponent > 0
            If (exponent Mod 2) = 1 Then
                result = (result * base) Mod modulus
            End If
            exponent = exponent / 2
            base = (base * base) Mod modulus
        Loop
        Return result
    End Function 'ModPowBig
