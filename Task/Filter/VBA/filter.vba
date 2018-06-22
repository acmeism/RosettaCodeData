Option Explicit

Sub Main()
Dim evens() As Long, i As Long
Dim numbers() As Long

    For i = 1 To 100000
        ReDim Preserve numbers(1 To i)
        numbers(i) = i
    Next i

    evens = FilterInNewArray(numbers)

    Debug.Print "Count of initial array : " & UBound(numbers) & ", first item : " & numbers(LBound(numbers)) & ", last item : " & numbers(UBound(numbers))
    Debug.Print "Count of new array : " & UBound(evens) & ", first item : " & evens(LBound(evens)) & ", last item : " & evens(UBound(evens))

    FilterInPlace numbers

    Debug.Print "Count of initial array (filtered): " & UBound(numbers) & ", first item : " & numbers(LBound(numbers)) & ", last item : " & numbers(UBound(numbers))
End Sub

Private Function FilterInNewArray(arr() As Long) As Long()
Dim i As Long, t() As Long, cpt As Long
    For i = LBound(arr) To UBound(arr)
        If IsEven(arr(i)) Then
            cpt = cpt + 1
            ReDim Preserve t(1 To cpt)
            t(cpt) = i
        End If
    Next i
    FilterInNewArray = t
End Function

Private Sub FilterInPlace(arr() As Long)
Dim i As Long, cpt As Long
    For i = LBound(arr) To UBound(arr)
        If IsEven(arr(i)) Then
            cpt = cpt + 1
            arr(cpt) = i
        End If
    Next i
    ReDim Preserve arr(1 To cpt)
End Sub

Private Function IsEven(Number As Long) As Boolean
    IsEven = (CLng(Right(CStr(Number), 1)) And 1) = 0
End Function
