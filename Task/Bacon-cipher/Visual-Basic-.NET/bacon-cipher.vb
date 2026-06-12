Imports System.Text

Module Module1

    ReadOnly CODES As New Dictionary(Of Char, String) From {
        {"a", "AAAAA"}, {"b", "AAAAB"}, {"c", "AAABA"}, {"d", "AAABB"}, {"e", "AABAA"},
        {"f", "AABAB"}, {"g", "AABBA"}, {"h", "AABBB"}, {"i", "ABAAA"}, {"j", "ABAAB"},
        {"k", "ABABA"}, {"l", "ABABB"}, {"m", "ABBAA"}, {"n", "ABBAB"}, {"o", "ABBBA"},
        {"p", "ABBBB"}, {"q", "BAAAA"}, {"r", "BAAAB"}, {"s", "BAABA"}, {"t", "BAABB"},
        {"u", "BABAA"}, {"v", "BABAB"}, {"w", "BABBA"}, {"x", "BABBB"}, {"y", "BBAAA"},
        {"z", "BBAAB"}, {" ", "BBBAA"} ' use " " To denote any non-letter
    }

    Function Encode(plainText As String, message As String) As String
        Dim pt = plainText.ToLower()
        Dim sb As New StringBuilder()
        For Each c In pt
            If "a" <= c AndAlso c <= "z" Then
                sb.Append(CODES(c))
            Else
                sb.Append(CODES(" "))
            End If
        Next

        Dim et = sb.ToString()
        Dim mg = message.ToLower() '"A"s to be in lower case, "B"s in upper case

        sb.Length = 0
        Dim count = 0
        For Each c In mg
            If "a" <= c AndAlso c <= "z" Then
                If et(count) = "A" Then
                    sb.Append(c)
                Else
                    sb.Append(Chr(Asc(c) - 32)) ' upper case equivalent
                End If
                count += 1
                If count = et.Length Then
                    Exit For
                End If
            Else
                sb.Append(c)
            End If
        Next

        Return sb.ToString()
    End Function

    Function Decode(message As String) As String
        Dim sb As New StringBuilder

        For Each c In message
            If "a" <= c AndAlso c <= "z" Then
                sb.Append("A")
            ElseIf "A" <= c AndAlso c <= "Z" Then
                sb.Append("B")
            End If
        Next

        Dim et = sb.ToString()
        sb.Length = 0
        For index = 0 To et.Length - 1 Step 5
            Dim quintet = et.Substring(index, 5)
            Dim key = CODES.Where(Function(a) a.Value = quintet).First().Key
            sb.Append(key)
        Next

        Return sb.ToString()
    End Function

    Sub Main()
        Dim plainText = "the quick brown fox jumps over the lazy dog"
        Dim message =
            "bacon's cipher is a method of steganography created by francis bacon. " +
            "this task is to implement a program for encryption and decryption of " +
            "plaintext using the simple alphabet of the baconian cipher or some " +
            "other kind of representation of this alphabet (make anything signify anything). " +
            "the baconian alphabet may optionally be extended to encode all lower " +
            "case characters individually and/or adding a few punctuation characters " +
            "such as the space."

        Dim cipherText = Encode(plainText, message)
        Console.WriteLine("Cipher text ->" & Environment.NewLine & "{0}", cipherText)

        Dim decodedText = Decode(cipherText)
        Console.WriteLine(Environment.NewLine & "Hidden text ->" & Environment.NewLine & "{0}", decodedText)
    End Sub

End Module
