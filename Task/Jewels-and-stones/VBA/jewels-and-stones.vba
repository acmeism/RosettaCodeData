Function count_jewels(stones As String, jewels As String) As Integer
    Dim res As Integer: res = 0
    For i = 1 To Len(stones)
        res = res - (InStr(1, jewels, Mid(stones, i, 1), vbBinaryCompare) <> 0)
    Next i
    count_jewels = res
End Function
Public Sub main()
    Debug.Print count_jewels("aAAbbbb", "aA")
    Debug.Print count_jewels("ZZ", "z")
End Sub
