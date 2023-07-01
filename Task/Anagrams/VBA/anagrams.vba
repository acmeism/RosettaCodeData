Option Explicit

Public Sub Main_Anagram()
Dim varReturn
Dim temp
Dim strContent As String
Dim strFile As String
Dim Num As Long
Dim i As Long
Dim countTime As Single

    'Open & read txt file
    Num = FreeFile
    strFile = "C:\Users\" & Environ("Username") & "\Desktop\unixdict.txt"
    Open strFile For Input As #Num
        strContent = Input(LOF(1), #Num)
    Close #Num
    Debug.Print UBound(Split(strContent, vbCrLf)) + 1 & " words, in the dictionary"
    countTime = Timer
    'Compute
    varReturn = Anagrams(strContent)
    'Return
    Debug.Print "The anagram set(s) with the greatest number of words (namely " & UBound(varReturn, 2) & ") is : "
    Debug.Print ""
    For i = LBound(varReturn, 1) To UBound(varReturn, 1)
        ReDim temp(LBound(varReturn, 2) To UBound(varReturn, 2))
        For Num = LBound(varReturn, 2) To UBound(varReturn, 2)
            temp(Num) = varReturn(i, Num)
        Next
        SortOneDimArray temp, LBound(temp), UBound(temp)
        Debug.Print Mid(Join(temp, ", "), 3)
    Next i
    Debug.Print ""
    Debug.Print "Time to go : " & Timer - countTime & " seconds."
End Sub

Private Function Anagrams(strContent As String) As Variant
Dim arrList
Dim arrTemp() As String
Dim arrReturn() As String
Dim Num As Long
Dim lngCountTemp As Long
Dim lngCount As Long
Dim i As Long

    'Put the content of txt file in an One Dim Array
    arrList = Split(strContent, vbCrLf)
    ReDim arrTemp(0 To UBound(arrList, 1), 0 To 2)
    'Transfer Datas in a 2nd Array Multi-Dim
        'Col 0 = words with letters sorted
        'Col 1 = words
        'Col 2 = Number of same words with letters sorted in the list
    For Num = LBound(arrList) To UBound(arrList)
        arrTemp(Num, 0) = SortLetters(CStr(arrList(Num)), Chr(0))
        arrTemp(Num, 1) = CStr(arrList(Num))
    Next
    SortTwoDimArray arrTemp, LBound(arrTemp, 1), UBound(arrTemp, 1), 0
    For Num = LBound(arrTemp, 1) To UBound(arrTemp, 1)
        arrTemp(Num, 2) = NbIf(arrTemp(Num, 0), arrTemp, Num, 0)
        If arrTemp(Num, 2) > lngCountTemp Then lngCountTemp = arrTemp(Num, 2)
    Next
    'return
    ReDim arrReturn(0 To lngCountTemp, 0)
    For Num = LBound(arrTemp, 1) To UBound(arrTemp, 1)
        If lngCountTemp = arrTemp(Num, 2) Then
            ReDim Preserve arrReturn(0 To lngCountTemp, 0 To lngCount)
            For i = 0 To lngCountTemp - 1
                arrReturn(i, lngCount) = arrTemp(Num + i, 1)
            Next i
            lngCount = lngCount + 1
        End If
    Next Num
    Anagrams = Transposition(arrReturn)
End Function

Private Function SortLetters(s As String, sep As String) As String
Dim temp

    temp = Split(StrConv(s, vbUnicode), sep)
    SortOneDimArray temp, LBound(temp), UBound(temp)
    SortLetters = Join(temp, sep)
End Function

Private Function NbIf(strValue As String, arr As Variant, lngInd As Long, Optional lngColumn As Long) As Long
Dim i As Long
Dim lngCount As Long

    For i = lngInd To UBound(arr, 1)
        If arr(i, lngColumn) = strValue Then
            lngCount = lngCount + 1
        Else
            Exit For
        End If
    Next i
    NbIf = lngCount
End Function

Private Function Transposition(ByRef myArr As Variant) As Variant
Dim tabl
Dim i As Long
Dim j As Long

    ReDim tabl(LBound(myArr, 2) To UBound(myArr, 2), LBound(myArr, 1) To UBound(myArr, 1))
    For i = LBound(myArr, 1) To UBound(myArr, 1)
        For j = LBound(myArr, 2) To UBound(myArr, 2)
            tabl(j, i) = myArr(i, j)
        Next j
    Next i
    Transposition = tabl
    Erase tabl
End Function

Private Sub SortOneDimArray(ByRef myArr As Variant, mini As Long, Maxi As Long)
Dim i As Long
Dim j As Long
Dim Pivot As Variant
Dim temp As Variant

    On Error Resume Next
    i = mini: j = Maxi
    Pivot = myArr((mini + Maxi) \ 2)
    While i <= j
        While myArr(i) < Pivot And i < Maxi: i = i + 1: Wend
        While Pivot < myArr(j) And j > mini: j = j - 1: Wend
        If i <= j Then
            temp = myArr(i)
            myArr(i) = myArr(j)
            myArr(j) = temp
            i = i + 1: j = j - 1
        End If
    Wend
    If (mini < j) Then Call SortOneDimArray(myArr, mini, j)
    If (i < Maxi) Then Call SortOneDimArray(myArr, i, Maxi)
End Sub

Private Sub SortTwoDimArray(ByRef myArr As Variant, mini As Long, Maxi As Long, Optional Colonne As Long = 0)
Dim i As Long
Dim j As Long
Dim Pivot As Variant
Dim myArrTemp As Variant
Dim ColTemp As Long

    On Error Resume Next
    i = mini: j = Maxi
    Pivot = myArr((mini + Maxi) \ 2, Colonne)
    While i <= j
        While myArr(i, Colonne) < Pivot And i < Maxi: i = i + 1: Wend
        While Pivot < myArr(j, Colonne) And j > mini: j = j - 1: Wend
        If i <= j Then
            ReDim myArrTemp(LBound(myArr, 2) To UBound(myArr, 2))
            For ColTemp = LBound(myArr, 2) To UBound(myArr, 2)
                myArrTemp(ColTemp) = myArr(i, ColTemp)
                myArr(i, ColTemp) = myArr(j, ColTemp)
                myArr(j, ColTemp) = myArrTemp(ColTemp)
            Next ColTemp
            Erase myArrTemp
            i = i + 1: j = j - 1
        End If
    Wend
    If (mini < j) Then Call SortTwoDimArray(myArr, mini, j, Colonne)
    If (i < Maxi) Then Call SortTwoDimArray(myArr, i, Maxi, Colonne)
End Sub
