Option Explicit

Sub Main_ABC()
Dim Arr, i As Long

    Arr = Array("A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE")
    For i = 0 To 6
        Debug.Print ">>> can_make_word " & Arr(i) & " => " & ABC(CStr(Arr(i)))
    Next i
End Sub

Function ABC(myWord As String) As Boolean
Dim myColl As New Collection
Dim NbLoop As Long, NbInit As Long
Dim b As Byte, i As Byte
Const BLOCKS As String = "B,O;X,K;D,Q;C,P;N,A;G,T;R,E;T,G;Q,D;F,S;J,W;H,U;V,I;A,N;O,B;E,R;F,S;L,Y;P,C;Z,M"

    For b = 0 To 19
        myColl.Add Split(BLOCKS, ";")(b), Split(BLOCKS, ";")(b) & b
    Next b
    NbInit = myColl.Count
    NbLoop = NbInit
    For b = 1 To Len(myWord)
        For i = 1 To NbLoop
            If i > NbLoop Then Exit For
            If InStr(myColl(i), Mid(myWord, b, 1)) <> 0 Then
                myColl.Remove (i)
                NbLoop = NbLoop - 1
                Exit For
            End If
        Next
    Next b
    ABC = (NbInit = (myColl.Count + Len(myWord)))
End Function
