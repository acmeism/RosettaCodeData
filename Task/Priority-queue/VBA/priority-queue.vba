Type Tuple
    Priority As Integer
    Data As String
End Type
Dim a() As Tuple
Dim n As Integer 'number of elements in array, last element is n-1
Private Function Left(i As Integer) As Integer
    Left = 2 * i + 1
End Function
Private Function Right(i As Integer) As Integer
    Right = 2 * i + 2
End Function
Private Function Parent(i As Integer) As Integer
    Parent = (i - 1) \ 2
End Function
Private Sub Add(fPriority As Integer, fData As String)
    n = n + 1
    If n > UBound(a) Then ReDim Preserve a(2 * n)
    a(n - 1).Priority = fPriority
    a(n - 1).Data = fData
    bubbleUp (n - 1)
End Sub
Private Sub Swap(i As Integer, j As Integer)
    Dim t As Tuple
    t = a(i)
    a(i) = a(j)
    a(j) = t
End Sub
Private Sub bubbleUp(i As Integer)
    Dim p As Integer
    p = Parent(i)
    Do While i > 0 And a(i).Priority < a(p).Priority
        Swap i, p
        i = p
        p = Parent(i)
    Loop
End Sub
Private Function Remove() As Tuple
    Dim x As Tuple
    x = a(0)
    a(0) = a(n - 1)
    n = n - 1
    trickleDown 0
    If 3 * n < UBound(a) Then ReDim Preserve a(UBound(a) \ 2)
    Remove = x
End Function
Private Sub trickleDown(i As Integer)
    Dim j As Integer, l As Integer, r As Integer
    Do
        j = -1
        r = Right(i)
        If r < n And a(r).Priority < a(i).Priority Then
            l = Left(i)
            If a(l).Priority < a(r).Priority Then
                j = l
            Else
                j = r
            End If
        Else
            l = Left(i)
            If l < n And a(l).Priority < a(i).Priority Then j = l
        End If
        If j >= 0 Then Swap i, j
        i = j
    Loop While i >= 0
End Sub
Public Sub PQ()
    ReDim a(4)
    Add 3, "Clear drains"
    Add 4, "Feed cat"
    Add 5, "Make tea"
    Add 1, "Solve RC tasks"
    Add 2, "Tax return"
    Dim t As Tuple
    Do While n > 0
        t = Remove
        Debug.Print t.Priority, t.Data
    Loop
End Sub
