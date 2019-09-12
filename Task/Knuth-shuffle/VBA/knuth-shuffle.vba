Private Sub Knuth(Optional ByRef a As Variant)
    Dim t As Variant, i As Integer
    If Not IsMissing(a) Then
        For i = UBound(a) To LBound(a) + 1 Step -1
            j = Int((UBound(a) - LBound(a) + 1) * Rnd + LBound(a))
            t = a(i)
            a(i) = a(j)
            a(j) = t
        Next i
    End If
End Sub
Public Sub program()
    Dim b As Variant, c As Variant, d As Variant, e As Variant
    Randomize
    'imagine an empty array on this line
    b = [{10}]
    c = [{10, 20}]
    d = [{10, 20, 30}]
    e = [{11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22}]
    f = [{"This ", "is ", "a ", "test"}]
    Debug.Print "Before:"
    Knuth 'feeding an empty array ;)
    Debug.Print "After: "
    Debug.Print "Before:";
    For Each i In b: Debug.Print i;: Next i: Debug.Print
    Knuth b
    Debug.Print "After: ";
    For Each i In b: Debug.Print i;: Next i: Debug.Print
    Debug.Print "Before:";
    For Each i In c: Debug.Print i;: Next i: Debug.Print
    Knuth c
    Debug.Print "After: ";
    For Each i In c: Debug.Print i;: Next i: Debug.Print
    Debug.Print "Before:";
    For Each i In d: Debug.Print i;: Next i: Debug.Print
    Knuth d
    Debug.Print "After: ";
    For Each i In d: Debug.Print i;: Next i: Debug.Print
    Debug.Print "Before:";
    For Each i In e: Debug.Print i;: Next i: Debug.Print
    Knuth e
    Debug.Print "After: ";
    For Each i In e: Debug.Print i;: Next i: Debug.Print
    Debug.Print "Before:";
    For Each i In f: Debug.Print i;: Next i: Debug.Print
    Knuth f
    Debug.Print "After: ";
    For Each i In f: Debug.Print i;: Next i: Debug.Print
End Sub
