Option Explicit
Sub Test()
    Dim h As Object
    Set h = CreateObject("Scripting.Dictionary")
    h.Add "A", 1
    h.Add "B", 2
    h.Add "C", 3
    Debug.Print h.Item("A")
    h.Item("C") = 4
    h.Key("C") = "D"
    Debug.Print h.exists("C")
    h.Remove "B"
    Debug.Print h.Count
    h.RemoveAll
    Debug.Print h.Count
End Sub
