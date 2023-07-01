 Function LevenshteinDistance(ByVal String1 As String, ByVal String2 As String) As Integer
        Dim Matrix(String1.Length, String2.Length) As Integer
        Dim Key As Integer
        For Key = 0 To String1.Length
            Matrix(Key, 0) = Key
        Next
        For Key = 0 To String2.Length
            Matrix(0, Key) = Key
        Next
        For Key1 As Integer = 1 To String2.Length
            For Key2 As Integer = 1 To String1.Length
                If String1(Key2 - 1) = String2(Key1 - 1) Then
                    Matrix(Key2, Key1) = Matrix(Key2 - 1, Key1 - 1)
                Else
                    Matrix(Key2, Key1) = Math.Min(Matrix(Key2 - 1, Key1) + 1, Math.Min(Matrix(Key2, Key1 - 1) + 1, Matrix(Key2 - 1, Key1 - 1) + 1))
                End If
            Next
        Next
        Return Matrix(String1.Length - 1, String2.Length - 1)
    End Function
