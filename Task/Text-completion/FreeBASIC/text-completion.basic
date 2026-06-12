#define MIN(a, b) iif((a) < (b), (a), (b))

Dim As String palabra = "complition"
Dim As Integer longitud = Len(palabra)
Open "unixdict.txt" For Input As #1
Dim As String cStr, wordList()
Dim As Integer n, p = 0, posic = 0
Do While Not Eof(1)
    Line Input #1, cStr
    p += 1
    If Len(cStr) > 8 Then
        posic += 1
        Redim Preserve wordList(posic)
        wordList(posic) = cStr
    End If
Loop
Close #1

Dim As String lev(4)
For n = Lbound(wordList) To Ubound(wordList)
    Dim As Integer ld = levenshtein(palabra, wordList(n))
    If ld < 4 Then lev(ld) &= wordList(n) & "  "
Next n

Print "Input word: "; palabra
For n = 1 To 3
    Dim As Integer semejanza = (longitud - n) * 100 / longitud
    Print Using !"\nWords at Levenshtein distance of # (##% similarity):"; n; semejanza
    Print lev(n); " ";
    Print
Next n
Sleep
