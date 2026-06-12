Sub Main_Contain()
Dim ListeWords() As String, Book As String, i As Long, out() As String, count As Integer
    Book = Read_File("C:\Users\" & Environ("Username") & "\Desktop\unixdict.txt")
    ListeWords = Split(Book, vbNewLine)
    For i = LBound(ListeWords) To UBound(ListeWords)
        If Len(ListeWords(i)) > 11 Then
            If InStr(ListeWords(i), "the") > 0 Then
                ReDim Preserve out(count)
                out(count) = ListeWords(i)
                count = count + 1
            End If
        End If
    Next
    Debug.Print "Found : " & count & " words : " & Join(out, ", ")
End Sub
Private Function Read_File(Fic As String) As String
Dim Nb As Integer
    Nb = FreeFile
    Open Fic For Input As #Nb
        Read_File = Input(LOF(Nb), #Nb)
    Close #Nb
End Function
