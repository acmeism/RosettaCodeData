Module Module1

    ReadOnly L_ALPHABET As String = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    ReadOnly R_ALPHABET As String = "PTLNBQDEOYSFAVZKGJRIHWXUMC"

    Enum Mode
        ENCRYPT
        DECRYPT
    End Enum

    Function Exec(text As String, mode As Mode, Optional showSteps As Boolean = False) As String
        Dim left = L_ALPHABET.ToCharArray()
        Dim right = R_ALPHABET.ToCharArray()
        Dim eText(text.Length - 1) As Char
        Dim temp(25) As Char

        For i = 0 To text.Length - 1
            If showSteps Then Console.WriteLine("{0} {1}", String.Join("", left), String.Join("", right))
            Dim index As Integer
            If mode = Mode.ENCRYPT Then
                index = Array.IndexOf(right, text(i))
                eText(i) = left(index)
            Else
                index = Array.IndexOf(left, text(i))
                eText(i) = right(index)
            End If
            If i = text.Length - 1 Then Exit For

            'permute left

            For j = index To 25
                temp(j - index) = left(j)
            Next
            For j = 0 To index - 1
                temp(26 - index + j) = left(j)
            Next
            Dim store = temp(1)
            For j = 2 To 13
                temp(j - 1) = temp(j)
            Next
            temp(13) = store
            temp.CopyTo(left, 0)

            'permute right

            For j = index To 25
                temp(j - index) = right(j)
            Next
            For j = 0 To index - 1
                temp(26 - index + j) = right(j)
            Next
            store = temp(0)
            For j = 1 To 25
                temp(j - 1) = temp(j)
            Next
            temp(25) = store
            store = temp(2)
            For j = 3 To 13
                temp(j - 1) = temp(j)
            Next
            temp(13) = store
            temp.CopyTo(right, 0)
        Next

        Return eText
    End Function

    Sub Main()
        Dim plainText = "WELLDONEISBETTERTHANWELLSAID"
        Console.WriteLine("The original plaintext is : {0}", plainText)
        Console.WriteLine(vbNewLine + "The left and right alphabets after each permutation during encryption are :" + vbNewLine)
        Dim cipherText = Exec(plainText, Mode.ENCRYPT, True)
        Console.WriteLine(vbNewLine + "The ciphertext is : {0}", cipherText)
        Dim plainText2 = Exec(cipherText, Mode.DECRYPT)
        Console.WriteLine(vbNewLine + "The recovered plaintext is : {0}", plainText2)
    End Sub

End Module
