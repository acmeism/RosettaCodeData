Option Explicit

Public Sub Nb_Classifications()
Dim A As New Collection, D As New Collection, P As New Collection
Dim n As Long, l As Long, s As String, t As Single

    t = Timer
    'Start
    For n = 1 To 20000
        l = SumPropers(n): s = CStr(n)
        Select Case n
            Case Is > l: D.Add s, s
            Case Is < l: A.Add s, s
            Case l: P.Add s, s
        End Select
    Next

    'End. Return :
    Debug.Print "Execution Time : " & Timer - t & " seconds."
    Debug.Print "-------------------------------------------"
    Debug.Print "Deficient := " & D.Count
    Debug.Print "Perfect := " & P.Count
    Debug.Print "Abundant := " & A.Count
End Sub

Private Function SumPropers(n As Long) As Long
'returns the sum of the proper divisors of n
Dim j As Long
    For j = 1 To n \ 2
        If n Mod j = 0 Then SumPropers = j + SumPropers
    Next
End Function
