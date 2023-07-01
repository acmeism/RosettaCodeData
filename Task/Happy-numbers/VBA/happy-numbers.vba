Option Explicit

Sub Test_Happy()
Dim i&, Cpt&

    For i = 1 To 100
        If Is_Happy_Number(i) Then
            Debug.Print "Is Happy : " & i
            Cpt = Cpt + 1
            If Cpt = 8 Then Exit For
        End If
    Next
End Sub

Public Function Is_Happy_Number(ByVal N As Long) As Boolean
Dim i&, Number$, Cpt&
    Is_Happy_Number = False 'default value
    Do
        Cpt = Cpt + 1       'Count Loops
        Number = CStr(N)    'conversion Long To String to be able to use Len() function
        N = 0
        For i = 1 To Len(Number)
            N = N + CInt(Mid(Number, i, 1)) ^ 2
        Next i
        'If Not N = 1 after 50 Loop ==> Number Is Not Happy
        If Cpt = 50 Then Exit Function
    Loop Until N = 1
    Is_Happy_Number = True
End Function
