Function shouldSwap(s As String, start As Integer, curr As Integer) As Boolean
    For i As Integer = start To curr - 1
        If Mid(s, i, 1) = Mid(s, curr, 1) Then Return False
    Next
    Return True
End Function

Sub findPerms(s As String, i As Integer, res() As String)
    If i > Len(s) Then
        Redim Preserve res(Lbound(res) To Ubound(res) + 1)
        res(Ubound(res)) = s
    Else
        For j As Integer = i To Len(s)
            If shouldSwap(s, i, j) Then
                Dim As String si = Mid(s, i, 1)
                Dim As String sj = Mid(s, j, 1)
                Mid(s, i, 1) = sj
                Mid(s, j, 1) = si
                findPerms(s, i + 1, res())
                Mid(s, i, 1) = si
                Mid(s, j, 1) = sj
            End If
        Next j
    End If
End Sub

Function createSlice(nums() As Integer, charSet As String) As String
    Dim As String chars = ""
    For i As Integer = Lbound(nums) To Ubound(nums)
        chars &= String(nums(i), Mid(charSet, i + 1, 1))
    Next i
    Return chars
End Function

Dim As String res1()
Dim As Integer nums1(1) = {2, 1}
findPerms(createSlice(nums1(), "12"), 1, res1())
For i As Integer = Lbound(res1) To Ubound(res1) : Print res1(i); " "; : Next
Print: Print

Dim As String res2()
Dim As Integer nums2(2) = {2, 3, 1}
findPerms(createSlice(nums2(), "123"), 1, res2())
For i As Integer = Lbound(res2) To Ubound(res2) : Print res2(i); " "; : Next
Print: Print

Dim As String res3()
findPerms(createSlice(nums2(), "ABC"), 1, res3())
For i As Integer = Lbound(res3) To Ubound(res3) : Print res3(i); " "; : Next

Sleep
