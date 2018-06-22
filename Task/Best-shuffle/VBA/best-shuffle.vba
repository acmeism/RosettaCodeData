Option Explicit

Sub Main_Best_shuffle()
Dim S() As Long, W, b As Byte, Anagram$, Count&, myB As Boolean, Limit As Byte, i As Integer

    W = Array("a", "abracadabra", "seesaw", "elk", "grrrrrr", "up", "qwerty", "tttt")
    For b = 0 To UBound(W)
        Count = 0
        Select Case Len(W(b))
            Case 1: Limit = 1
            Case Else
                i = NbLettersDiff(W(b))
                If i >= Len(W(b)) \ 2 Then
                    Limit = 0
                ElseIf i = 1 Then
                    Limit = Len(W(b))
                Else
                    Limit = Len(W(b)) - i
                End If
        End Select
RePlay:
        Do
            S() = ShuffleIntegers(Len(W(b)))
            myB = GoodShuffle(S, Limit)
        Loop While Not myB
        Anagram = ShuffleWord(CStr(W(b)), S)
        Count = Nb(W(b), Anagram)
        If Count > Limit Then GoTo RePlay
        Debug.Print W(b) & " ==> " & Anagram & " (Score : " & Count & ")"
    Next
End Sub

Function ShuffleIntegers(l As Long) As Long()
Dim i As Integer, ou As Integer, temp() As Long
Dim C As New Collection

    ReDim temp(l - 1)
    If l = 1 Then
        temp(0) = 0
    ElseIf l = 2 Then
        temp(0) = 1: temp(1) = 0
    Else
        Randomize
        Do
            ou = Int(Rnd * l)
            On Error Resume Next
            C.Add CStr(ou), CStr(ou)
            If Err <> 0 Then
                On Error GoTo 0
            Else
                temp(ou) = i
                i = i + 1
            End If
        Loop While C.Count <> l
    End If
    ShuffleIntegers = temp
End Function

Function GoodShuffle(t() As Long, Lim As Byte) As Boolean
Dim i&, C&

    For i = LBound(t) To UBound(t)
        If t(i) = i Then C = C + 1
    Next i
    GoodShuffle = (C <= Lim)
End Function

Function ShuffleWord(W$, S() As Long) As String
Dim i&, temp, strR$

    temp = Split(StrConv(W, vbUnicode), Chr(0))
    For i = 0 To UBound(S)
        strR = strR & temp(S(i))
    Next i
    ShuffleWord = strR
End Function

Function Nb(W, A) As Integer
Dim i As Integer, l As Integer

    For i = 1 To Len(W)
        If Mid(W, i, 1) = Mid(A, i, 1) Then l = l + 1
    Next i
    Nb = l
End Function

Function NbLettersDiff(W) As Integer
Dim i&, C As New Collection
    For i = 1 To Len(W)
        On Error Resume Next
        C.Add Mid(W, i, 1), Mid(W, i, 1)
    Next i
    NbLettersDiff = C.Count
End Function
