Public queue As New Collection

Private Sub push(what As Variant)
    queue.Add what
End Sub

Private Function pop() As Variant
    If queue.Count > 0 Then
        what = queue(1)
        queue.Remove 1
    Else
        what = CVErr(461)
    End If
    pop = what
End Function

Private Function empty_()
    empty_ = queue.Count = 0
End Function
