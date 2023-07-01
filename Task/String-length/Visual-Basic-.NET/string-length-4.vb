#Const PRINT_TESTCASE = True

Module Program
    ReadOnly TestCases As String() =
    {
        "Hello, world!",
        "møøse",
        "𝔘𝔫𝔦𝔠𝔬𝔡𝔢", ' String normalization of the file makes the e and diacritic in é̲ one character, so use VB's char "escapes"
        $"J{ChrW(&H332)}o{ChrW(&H332)}s{ChrW(&H332)}e{ChrW(&H301)}{ChrW(&H332)}"
    }

    Sub Main()
        Const INDENT = "    "
        Console.OutputEncoding = Text.Encoding.Unicode

        Dim writeResult = Sub(s As String, result As Integer) Console.WriteLine("{0}{1,-20}{2}", INDENT, s, result)

        For i = 0 To TestCases.Length - 1
            Dim c = TestCases(i)

            Console.Write("Test case " & i)
#If PRINT_TESTCASE Then
            Console.WriteLine(": " & c)
#Else
            Console.WriteLine()
#End If
            writeResult("graphemes", GraphemeCount(c))
            writeResult("UTF-16 units", GetUTF16CodeUnitsLength(c))
            writeResult("Cd pts from UTF-16", GetCharacterLength_FromUTF16(c))
            writeResult("Cd pts from UTF-32", GetCharacterLength_FromUTF32(c))
            Console.WriteLine()
            writeResult("bytes (UTF-8)", GetByteLength(c, Text.Encoding.UTF8))
            writeResult("bytes (UTF-16)", GetByteLength(c, Text.Encoding.Unicode))
            writeResult("bytes (UTF-32)", GetByteLength(c, Text.Encoding.UTF32))
            Console.WriteLine()
        Next

    End Sub
End Module
