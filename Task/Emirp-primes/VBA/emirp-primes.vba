Option Explicit

Private Const MAX As Long = 5000000
Private Emirps As New Collection
Private CollTemp As New Collection

Sub Main()
Dim t
t = Timer
    FillCollectionOfEmirps
    Debug.Print "At this point : Execution time = " & Timer - t & " seconds."
    Debug.Print "We have a Collection of the " & Emirps.Count & " first Emirps."
    Debug.Print "---------------------------"
    'show the first   twenty   emirps
    Debug.Print "the first 20 emirps: "; ExtractEmirps(1, 20)
    'show all emirps between 7,700 and 8,000
    Debug.Print "all emirps between 7,700 and 8,000: "; ExtractEmirps(7700, 8000, True)
    'show the   10,000th   emirp
    Debug.Print "the 10,000th emirp: "; ExtractEmirps(10000, 10000)
  End Sub

Private Function ExtractEmirps(First As Long, Last As Long, Optional Value = False) As String
Dim temp$, i As Long, e
    If First = Last Then
        ExtractEmirps = Emirps(First)
    Else
        If Not Value Then
            For i = First To Last
                temp = temp & ", " & Emirps(i)
            Next
        Else
            For Each e In Emirps
                If e > First And e < Last Then
                    temp = temp & ", " & e
                End If
                If e = Last Then Exit For
            Next e
        End If
        ExtractEmirps = Mid(temp, 3)
    End If
End Function

Private Sub FillCollectionOfEmirps()
Dim Primes() As Long, e, i As Long
    Primes = Atkin
    For i = LBound(Primes) To UBound(Primes)
        CollTemp.Add Primes(i), CStr(Primes(i))
    Next i
    For Each e In CollTemp
        If IsEmirp(e) Then Emirps.Add e
    Next
End Sub

Private Function Atkin() As Long()
Dim MyBool() As Boolean
Dim SQRT_MAX As Long, i&, j&, N&, cpt&, MAX_TEMP As Long, temp() As Long
    ReDim MyBool(MAX)
    SQRT_MAX = Sqr(MAX) + 1
    MAX_TEMP = Sqr(MAX / 4) + 1
    For i = 1 To MAX_TEMP
        For j = 1 To SQRT_MAX
            N = 4 * i * i + j * j
            If N <= MAX And (N Mod 12 = 1 Or N Mod 12 = 5) Then
                MyBool(N) = True
            End If
        Next j
    Next i
    MAX_TEMP = Sqr(MAX / 3) + 1
    For i = 1 To MAX_TEMP
        For j = 1 To SQRT_MAX
            N = 3 * i * i + j * j
            If N <= MAX And N Mod 12 = 7 Then
                MyBool(N) = True
            End If
        Next j
    Next i
    For i = 1 To SQRT_MAX
        For j = 1 To SQRT_MAX
            N = 3 * i * i - j * j
            If i > j And N <= MAX And N Mod 12 = 11 Then
                MyBool(N) = True
            End If
        Next j
    Next i
    For i = 5 To SQRT_MAX Step 2
        If MyBool(i) Then
            For j = i * i To MAX Step i
                MyBool(j) = False
            Next
        End If
    Next
    ReDim temp(MAX / 2)
    temp(0) = 2: temp(1) = 3: cpt = 2
    For i = 5 To MAX Step 2
        If MyBool(i) Then temp(cpt) = i: cpt = cpt + 1
    Next
    ReDim Preserve temp(cpt - 1)
    Atkin = temp
End Function

Private Function IsEmirp(N) As Boolean
Dim a As String, b As String
    a = StrReverse(CStr(N)): b = CStr(N)
    If a <> b Then
        On Error Resume Next
        CollTemp.Add a, a
        If Err.Number > 0 Then
            IsEmirp = True
        Else
            CollTemp.Remove a
        End If
        On Error GoTo 0
    End If
End Function
