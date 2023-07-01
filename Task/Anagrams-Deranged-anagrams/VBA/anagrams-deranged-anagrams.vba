Sub Main_DerangedAnagrams()
Dim ListeWords() As String, Book As String, i As Long, j As Long, tempLen As Integer, MaxLen As Integer, tempStr As String, IsDeranged As Boolean, count As Integer, bAnag As Boolean
Dim t As Single
t = Timer
    Book = Read_File("C:\Users\" & Environ("Username") & "\Desktop\unixdict.txt")
    ListeWords = Split(Book, vbNewLine)
    For i = LBound(ListeWords) To UBound(ListeWords) - 1
        For j = i + 1 To UBound(ListeWords)
            If Len(ListeWords(i)) = Len(ListeWords(j)) Then
                tempLen = 0
                IsDeranged = False
                bAnag = IsAnagram(ListeWords(i), ListeWords(j), IsDeranged, tempLen)
                If IsDeranged Then
                    count = count + 1
                    If tempLen > MaxLen Then
                        MaxLen = tempLen
                        tempStr = ListeWords(i) & ", " & ListeWords(j)
                    End If
                End If
            End If
        Next j
    Next i
    Debug.Print "There is : " & count & " deranged anagram, in unixdict.txt."
    Debug.Print "The longest is : " & tempStr
    Debug.Print "Lenght  : " & MaxLen
    Debug.Print "Time to compute : " & Timer - t & " sec."
End Sub
Private Function Read_File(Fic As String) As String
Dim Nb As Integer
    Nb = FreeFile
    Open Fic For Input As #Nb
        Read_File = Input(LOF(Nb), #Nb)
    Close #Nb
End Function
Function IsAnagram(str1 As String, str2 As String, DerangedAnagram As Boolean, Lenght As Integer) As Boolean
Dim i As Integer
    str1 = Trim(UCase(str1))
    str2 = Trim(UCase(str2))
    For i = 1 To Len(str1)
        If Len(Replace(str1, Mid$(str1, i, 1), vbNullString)) <> Len(Replace(str2, Mid$(str1, i, 1), vbNullString)) Then
            Exit Function
        End If
        If Mid$(str1, i, 1) = Mid$(str2, i, 1) Then
            Exit Function
        End If
    Next i
    IsAnagram = True
    DerangedAnagram = True
    Lenght = Len(str1)
End Function
