Dim As String list1(1 To 2, 1 To 3) = {{"a", "b", "c"}, {"a", "b", "c"}}
Dim As String list2(1 To 2, 1 To 3) = {{"1", "2", "3"}, {"1", "2", "3"}}

Sub permutation(list() As String)
    Dim As Integer n, m
    For n = Lbound(list,2) To Ubound(list,2)
        For m = Lbound(list,2) To Ubound(list,2)
            Print list(1, n); " "; list(2, m)
        Next m
    Next n
    Print
End Sub

permutation(list1())
Print
permutation(list2())
Sleep
