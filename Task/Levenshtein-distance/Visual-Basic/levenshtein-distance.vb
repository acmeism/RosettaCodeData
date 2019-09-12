Function min(x As Integer, y As Integer) As Integer
    If x < y Then
        min = x
    Else
        min = y
    End If
End Function

Function levenshtein(s As String, t As String) As Integer
Dim ls As Integer, lt As Integer
Dim i As Integer, j As Integer, cost As Integer
    ' degenerate cases
    ls = Len(s)
    lt = Len(t)
    If ls = lt Then
        If s = t Then
            Exit Function ' return 0
        End If
    ElseIf ls = 0 Then
        levenshtein = lt
        Exit Function
    ElseIf lt = 0 Then
        levenshtein = ls
        Exit Function
    End If

    ' create two integer arrays of distances
    ReDim v0(0 To lt) As Integer  '' previous
    ReDim v1(0 To lt) As Integer  '' current

    ' initialize v0
    For i = 0 To lt
        v0(i) = i
    Next i

    For i = 0 To ls - 1
       ' calculate v1 from v0
       v1(0) = i + 1

       For j = 0 To lt - 1
           cost = Abs(CInt(Mid$(s, i + 1, 1) <> Mid$(t, j + 1, 1)))
           v1(j + 1) = min(v1(j) + 1, min(v0(j + 1) + 1, v0(j) + cost))
       Next j

       ' copy v1 to v0 for next iteration
       For j = 0 To lt
           v0(j) = v1(j)
       Next j
    Next i

    levenshtein = v1(lt)
End Function

Sub Main()
' tests
    Debug.Print "'kitten' to 'sitting'            => "; levenshtein("kitten", "sitting")
    Debug.Print "'sitting' to 'kitten'            => "; levenshtein("sitting", "kitten")
    Debug.Print "'rosettacode' to 'raisethysword' => "; levenshtein("rosettacode", "raisethysword")
    Debug.Print "'sleep' to 'fleeting'            => "; levenshtein("sleep", "fleeting")
End Sub
