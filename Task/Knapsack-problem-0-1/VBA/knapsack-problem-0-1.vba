'Knapsack problem/0-1 - 12/02/2017
Option Explicit
Const maxWeight = 400
Dim DataList As Variant
Dim xList(64, 3) As Variant
Dim nItems As Integer
Dim s As String, xss As String
Dim xwei As Integer, xval As Integer, nn As Integer

Sub Main()
    Dim i As Integer, j As Integer
    DataList = Array("map", 9, 150, "compass", 13, 35, "water", 153, 200, "sandwich", 50, 160, _
           "glucose", 15, 60, "tin", 68, 45, "banana", 27, 60, "apple", 39, 40, _
           "cheese", 23, 30, "beer", 52, 10, "suntan cream", 11, 70, "camera", 32, 30, _
           "T-shirt", 24, 15, "trousers", 48, 10, "umbrella", 73, 40, "book", 30, 10, _
           "waterproof trousers", 42, 70, "waterproof overclothes", 43, 75, _
           "note-case", 22, 80, "sunglasses", 7, 20, "towel", 18, 12, "socks", 4, 50)
    nItems = (UBound(DataList) + 1) / 3
    j = 0
    For i = 1 To nItems
        xList(i, 1) = DataList(j)
        xList(i, 2) = DataList(j + 1)
        xList(i, 3) = DataList(j + 2)
        j = j + 3
    Next i
    s = ""
    For i = 1 To nItems
        s = s & Chr(i)
    Next
    nn = 0
    Call ChoiceBin(1, "")
    For i = 1 To Len(xss)
        j = Asc(Mid(xss, i, 1))
        Debug.Print xList(j, 1)
    Next i
    Debug.Print "count=" & Len(xss), "weight=" & xwei, "value=" & xval
End Sub 'Main

Private Sub ChoiceBin(n As String, ss As String)
    Dim r As String
    Dim i As Integer, j As Integer, iwei As Integer, ival As Integer
    Dim ipct As Integer
    If n = Len(s) + 1 Then
        iwei = 0: ival = 0
        For i = 1 To Len(ss)
            j = Asc(Mid(ss, i, 1))
            iwei = iwei + xList(j, 2)
            ival = ival + xList(j, 3)
        Next
        If iwei <= maxWeight And ival > xval Then
            xss = ss: xwei = iwei: xval = ival
        End If
    Else
        r = Mid(s, n, 1)
        Call ChoiceBin(n + 1, ss & r)
        Call ChoiceBin(n + 1, ss)
    End If
End Sub 'ChoiceBin
