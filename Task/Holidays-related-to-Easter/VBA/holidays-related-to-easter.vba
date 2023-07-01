Public dates As Variant
Private Function easter(year_ As Integer) As Date
'-- from https://en.wikipedia.org/wiki/Computus#Anonymous_Gregorian_algorithm
    Dim a As Integer, b As Integer, c As Integer, d As Integer, e As Integer
    Dim f As Integer, g As Integer, h As Integer, i As Integer, k As Integer
    Dim l As Integer, m As Integer, n As Integer
    a = year_ Mod 19
    b = year_ \ 100
    c = year_ Mod 100
    d = b \ 4
    e = b Mod 4
    f = (b + 8) \ 25
    g = (b - f + 1) \ 3
    h = (19 * a + b - d - g + 15) Mod 30
    i = c \ 4
    k = c Mod 4
    l = (32 + 2 * e + 2 * i - h - k) Mod 7
    m = (a + 11 * h + 22 * l) \ 451
    n = h + l - 7 * m + 114
    month_ = n \ 31
    day_ = n Mod 31 + 1
    easter = DateSerial(year_, month_, day_)
End Function

Private Sub show(year_ As Integer)
    If year_ = 0 Then
        Debug.Print , "Easter", "Ascension", "Pentecost", "Trinity", "Corpus"
    Else
        Dim e As Date
        e = easter(year_)
        Debug.Print Format(year_, "@@@@"),
        For i = 1 To UBound(dates)
            Debug.Print Format(e + dates(i, 2), "ddd dd mmm"),
        Next i
        Debug.Print
    End If
End Sub

Public Sub main()
    Dim year_ As Integer
    dates = [{"Easter   ",0; "Ascension",39; "Pentecost",49; "Trinity  ",56; "Corpus   ",60}]
    show 0
    For year_ = 400 To 2000 Step 100
        show year_
    Next year_
    Debug.Print
    show 0
    For year_ = 2010 To 2020
        show year_
    Next year_
End Sub
