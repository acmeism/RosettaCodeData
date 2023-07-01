Module Module1

   Private Function rot13(ByVal str As String) As String
       Dim newChars As Char(), i, j As Integer, original, replacement As String

       original = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
       replacement = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"

       newChars = str.ToCharArray()

       For i = 0 To newChars.Length - 1
           For j = 0 To 51
               If newChars(i) = original(j) Then
                   newChars(i) = replacement(j)
                   Exit For
               End If
           Next
       Next

       Return New String(newChars)
   End Function

End Module
