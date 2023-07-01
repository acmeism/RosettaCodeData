Option Explicit

Private Sub LeonardoNumbers()
Dim L, MyString As String
    Debug.Print "First 25 Leonardo numbers :"
    L = Leo_Numbers(25, 1, 1, 1)
    MyString = Join(L, "; ")
    Debug.Print MyString
    Debug.Print "First 25 Leonardo numbers from 0, 1 with add number = 0"
    L = Leo_Numbers(25, 0, 1, 0)
    MyString = Join(L, "; ")
    Debug.Print MyString
    Debug.Print "If the first prarameter is too small :"
    L = Leo_Numbers(1, 0, 1, 0)
    MyString = Join(L, "; ")
    Debug.Print MyString
End Sub

Public Function Leo_Numbers(HowMany As Long, L_0 As Long, L_1 As Long, Add_Nb As Long)
Dim N As Long, Ltemp

    If HowMany > 1 Then
        ReDim Ltemp(HowMany - 1)
        Ltemp(0) = L_0: Ltemp(1) = L_1
        For N = 2 To HowMany - 1
             Ltemp(N) = Ltemp(N - 1) + Ltemp(N - 2) + Add_Nb
        Next N
    Else
        ReDim Ltemp(0)
        Ltemp(0) = "The first parameter is too small"
    End If
    Leo_Numbers = Ltemp
End Function
