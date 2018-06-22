Option Explicit

Public Sub AmicablePairs()
Dim a(2 To 20000) As Long, c As New Collection, i As Long, j As Long, t#
    t = Timer
    For i = LBound(a) To UBound(a)
        'collect the sum of the proper divisors
        'of each numbers between 2 and 20000
        a(i) = S(i)
    Next
    'Double Loops to test the amicable
    For i = LBound(a) To UBound(a)
        For j = i + 1 To UBound(a)
            If i = a(j) Then
                If a(i) = j Then
                     On Error Resume Next
                     c.Add i & " : " & j, CStr(i * j)
                     On Error GoTo 0
                     Exit For
                End If
            End If
        Next
    Next
    'End. Return :
    Debug.Print "Execution Time : " & Timer - t & " seconds."
    Debug.Print "Amicable pairs below 20 000 are : "
    For i = 1 To c.Count
        Debug.Print c.Item(i)
    Next i
End Sub

Private Function S(n As Long) As Long
'returns the sum of the proper divisors of n
Dim j As Long
    For j = 1 To n \ 2
        If n Mod j = 0 Then S = j + S
    Next
End Function
