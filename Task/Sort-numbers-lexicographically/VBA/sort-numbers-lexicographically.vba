Public Function sortlexicographically(N As Integer)
    Dim arrList As Object
    Set arrList = CreateObject("System.Collections.ArrayList")
    For i = 1 To N
        arrList.Add CStr(i)
    Next i
    arrList.Sort
    Dim item As Variant
    For Each item In arrList
        Debug.Print item & ", ";
    Next
End Function

Public Sub main()
    Call sortlexicographically(13)
End Sub
