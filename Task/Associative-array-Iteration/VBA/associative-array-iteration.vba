Option Explicit
Sub Test()
    Dim h As Object, i As Long, u, v, s
    Set h = CreateObject("Scripting.Dictionary")
    h.Add "A", 1
    h.Add "B", 2
    h.Add "C", 3

    'Iterate on keys
    For Each s In h.Keys
        Debug.Print s
    Next

    'Iterate on values
    For Each s In h.Items
        Debug.Print s
    Next

    'Iterate on both keys and values by creating two arrays
    u = h.Keys
    v = h.Items
    For i = 0 To h.Count - 1
        Debug.Print u(i), v(i)
    Next
End Sub
