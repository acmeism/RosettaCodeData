        Dim i As Integer '32-bit signed integer
        Try
            i = -2147483647 : i = -(i - 1)
            Debug.Print(i)
        Catch ex As Exception
            Debug.Print("Exception raised : " & ex.Message)
        End Try
