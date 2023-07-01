Module ByteLength
    Function GetByteLength(s As String, encoding As Text.Encoding) As Integer
        Return encoding.GetByteCount(s)
    End Function
End Module
