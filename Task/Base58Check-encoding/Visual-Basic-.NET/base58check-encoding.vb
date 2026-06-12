Imports System.Numerics
Imports System.Text

Module Module1
    ReadOnly ALPHABET As String = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    ReadOnly HEX As String = "0123456789ABCDEF"

    Function ToBigInteger(value As String, base As Integer) As BigInteger
        If base < 1 OrElse base > HEX.Length Then
            Throw New ArgumentException("Base is out of range.")
        End If

        Dim bi = BigInteger.Zero
        For Each c In value
            Dim c2 = Char.ToUpper(c)
            Dim idx = HEX.IndexOf(c2)
            If idx = -1 OrElse idx >= base Then
                Throw New ArgumentException("Illegal character encountered.")
            End If
            bi = bi * base + idx
        Next

        Return bi
    End Function

    Function ConvertToBase58(hash As String, Optional base As Integer = 16) As String
        Dim x As BigInteger
        If base = 16 AndAlso hash.Substring(0, 2) = "0x" Then
            x = ToBigInteger(hash.Substring(2), base)
        Else
            x = ToBigInteger(hash, base)
        End If

        Dim sb As New StringBuilder
        While x > 0
            Dim r = x Mod 58
            sb.Append(ALPHABET(r))
            x = x / 58
        End While

        Dim ca = sb.ToString().ToCharArray()
        Array.Reverse(ca)
        Return New String(ca)
    End Function

    Sub Main()
        Dim s = "25420294593250030202636073700053352635053786165627414518"
        Dim b = ConvertToBase58(s, 10)
        Console.WriteLine("{0} -> {1}", s, b)

        Dim hashes = {"0x61", "0x626262", "0x636363", "0x73696d706c792061206c6f6e6720737472696e67", "0x516b6fcd0f", "0xbf4f89001e670274dd", "0x572e4794", "0xecac89cad93923c02321", "0x10c8511e"}
        For Each hash In hashes
            Dim b58 = ConvertToBase58(hash)
            Console.WriteLine("{0,-56} -> {1}", hash, b58)
        Next
    End Sub

End Module
