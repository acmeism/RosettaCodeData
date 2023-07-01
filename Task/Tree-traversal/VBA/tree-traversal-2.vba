Dim tihead As TreeItem

Private Function Add(v As Integer, left As TreeItem, right As TreeItem) As TreeItem
    Dim x As New TreeItem
    x.Value = v
    Set x.LeftChild = left
    Set x.RightChild = right
    Set Add = x
End Function

Private Sub Init()
    Set tihead = Add(1, _
                    Add(2, _
                        Add(4, _
                            Add(7, Nothing, Nothing), _
                            Nothing), _
                        Add(5, Nothing, Nothing)), _
                    Add(3, _
                        Add(6, _
                            Add(8, Nothing, Nothing), _
                            Add(9, Nothing, Nothing)), _
                        Nothing))
End Sub

Private Sub InOrder(ti As TreeItem)
    If Not ti Is Nothing Then
        Call InOrder(ti.LeftChild)
        Debug.Print ti.Value;
        Call InOrder(ti.RightChild)
    End If
End Sub

Private Sub PreOrder(ti As TreeItem)
    If Not ti Is Nothing Then
        Debug.Print ti.Value;
        Call PreOrder(ti.LeftChild)
        Call PreOrder(ti.RightChild)
    End If
End Sub

Private Sub PostOrder(ti As TreeItem)
    If Not ti Is Nothing Then
        Call PostOrder(ti.LeftChild)
        Call PostOrder(ti.RightChild)
        Debug.Print ti.Value;
    End If
End Sub

Private Sub LevelOrder(ti As TreeItem)
    Dim queue As Object
    Set queue = CreateObject("System.Collections.Queue")
    queue.Enqueue ti
    Do While (queue.Count > 0)
        Set next_ = queue.Dequeue
        Debug.Print next_.Value;
        If Not next_.LeftChild Is Nothing Then queue.Enqueue next_.LeftChild
        If Not next_.RightChild Is Nothing Then queue.Enqueue next_.RightChild
    Loop
End Sub

Public Sub Main()
    Init
    Debug.Print "preorder:     ";
    Call PreOrder(tihead)
    Debug.Print vbCrLf; "inorder:      ";
    Call InOrder(tihead)
    Debug.Print vbCrLf; "postorder:    ";
    Call PostOrder(tihead)
    Debug.Print vbCrLf; "level-order:  ";
    Call LevelOrder(tihead)
End Sub
