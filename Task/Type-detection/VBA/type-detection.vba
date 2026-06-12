Public Sub main()
    Dim c(1) As Currency
    Dim d(1) As Double
    Dim dt(1) As Date
    Dim a(1) As Integer
    Dim l(1) As Long
    Dim s(1) As Single
    Dim e As Variant
    Dim o As Object
    Set o = New Application
    Debug.Print TypeName(o)
    Debug.Print TypeName(1 = 1)
    Debug.Print TypeName(CByte(1))
    Set o = New Collection
    Debug.Print TypeName(o)
    Debug.Print TypeName(1@)
    Debug.Print TypeName(c)
    Debug.Print TypeName(CDate(1))
    Debug.Print TypeName(dt)
    Debug.Print TypeName(CDec(1))
    Debug.Print TypeName(1#)
    Debug.Print TypeName(d)
    Debug.Print TypeName(e)
    Debug.Print TypeName(CVErr(1))
    Debug.Print TypeName(1)
    Debug.Print TypeName(a)
    Debug.Print TypeName(1&)
    Debug.Print TypeName(l)
    Set o = Nothing
    Debug.Print TypeName(o)
    Debug.Print TypeName([A1])
    Debug.Print TypeName(1!)
    Debug.Print TypeName(s)
    Debug.Print TypeName(CStr(1))
    Debug.Print TypeName(Worksheets(1))
End Sub
