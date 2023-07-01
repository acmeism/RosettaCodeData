Module Module1

    Sub Main()
        Dim data = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="
        Console.WriteLine(data)
        Console.WriteLine()

        Dim decoded = Text.Encoding.ASCII.GetString(Convert.FromBase64String(data))
        Console.WriteLine(decoded)
    End Sub

End Module
