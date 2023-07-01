Function IsInArray(stringToBeFound As Variant, arr As Variant, _
    Optional start As Integer = 1, Optional reverse As Boolean = False) As Long
'Adapted from https://stackoverflow.com/questions/12414168/use-of-custom-data-types-in-vba
    Dim i As Long, lo As Long, hi As Long, stp As Long
    ' default return value if value not found in array
    IsInArray = -1
    If reverse Then
        lo = UBound(arr): hi = start: stp = -1
    Else
        lo = start: hi = UBound(arr): stp = 1
    End If
    For i = lo To hi Step stp 'start in stead of LBound(arr)
        If StrComp(stringToBeFound, arr(i), vbTextCompare) = 0 Then
            IsInArray = i
            Exit For
        End If
    Next i
End Function
Public Sub search_a_list()
    Dim haystack() As Variant, needles() As Variant
    haystack = [{"Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"}]
    needles = [{"Washington","Bush"}]
    For i = 1 To 2
        If IsInArray(needles(i), haystack) = -1 Then
            Debug.Print needles(i); " not found in haystack."
        Else
            Debug.Print needles(i); " is at position "; CStr(IsInArray(needles(i), haystack)); ".";
            Debug.Print " And last position is ";
            Debug.Print CStr(IsInArray(needles(i), haystack, 1, True)); "."
        End If
    Next i
End Sub
