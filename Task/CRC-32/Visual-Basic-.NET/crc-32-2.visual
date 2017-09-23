    ' Returns a Byte Array from a string of ASCII characters.
    Function Str2BA(Str As String) As Byte()
        Return System.Text.Encoding.ASCII.GetBytes(Str)
    End Function

    ' Returns a Hex string from an UInteger, formatted to a number of digits,
    '  adding leading zeros If necessary.
    Function HexF(Value As UInteger, Digits As Integer) As String
        HexF = Hex(Value)
        If Len(HexF) < Digits Then HexF = StrDup(Digits - Len(HexF), "0") & HexF
    End Function

    ' Tests Crc32 class
    Sub Test()
        Dim Str As String = "The quick brown fox jumps over the lazy dog"
        Debug.Print("Input = """ & Str & """")
        ' Convert string to Byte Array, compute crc32, and display formatted result
        Debug.Print("Crc32 = " & HexF(Crc32.cs(Str2BA(Str)), 8))
        ' This next code demonstrates continuing a crc32 calculation when breaking the input
        ' into pieces, such as processing a large file by a series of buffer reads.
        Crc32.cs(Str2BA(Mid(Str, 1, 20)))
        Debug.Print("Crc32 = " & HexF(Crc32.cs(Str2BA(Mid(Str, 21)), False), 8))
    End Sub
