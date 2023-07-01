Module CharacterLength
    Function GetUTF16CodeUnitsLength(s As String) As Integer
        Return s.Length
    End Function

    Private Function GetUTF16SurrogatePairCount(s As String) As Integer
        GetUTF16SurrogatePairCount = 0
        For i = 1 To s.Length - 1
            If Char.IsSurrogatePair(s(i - 1), s(i)) Then GetUTF16SurrogatePairCount += 1
        Next
    End Function

    Function GetCharacterLength_FromUTF16(s As String) As Integer
        Return GetUTF16CodeUnitsLength(s) - GetUTF16SurrogatePairCount(s)
    End Function

    Function GetCharacterLength_FromUTF32(s As String) As Integer
        Return GetByteLength(s, Text.Encoding.UTF32) \ 4
    End Function
End Module
