Option Explicit

Sub Main_Bulls_And_Cows_Player()
Dim collSoluces As New Collection, Elem As Variant, Soluce As String
Dim strNumber As String, cpt As Byte, p As Byte
Dim i As Byte, Bulls() As Boolean, NbBulls As Byte, Cows As Byte, Poss As Long
Const NUMBER_OF_DIGITS As Byte = 4

        strNumber = CreateNb(NUMBER_OF_DIGITS)
        Debug.Print "TOSS : " & StrConv(strNumber, vbUnicode)
        Debug.Print "---------- START ------------"
        Set collSoluces = CollOfPossibleNumbers
        Poss = collSoluces.Count
        For Each Elem In collSoluces
            'Debug.Print "Number of possibilities : " & Poss
            Debug.Print "Attempt : " & StrConv(Elem, vbUnicode)
            NbBulls = 0: Soluce = Elem
            ReDim Bulls(NUMBER_OF_DIGITS - 1)
            For i = 1 To NUMBER_OF_DIGITS
                If IsBull(strNumber, Mid(Elem, i, 1), i) Then
                    Bulls(i - 1) = True: NbBulls = NbBulls + 1
                    RemoveIfNotBull collSoluces, Mid(Elem, i, 1), i
                End If
            Next i
            Cows = 0
            For i = 1 To NUMBER_OF_DIGITS
                If Not Bulls(i - 1) Then
                    If IsCow(collSoluces, strNumber, Mid(Elem, i, 1), p) Then
                        If Not Bulls(p - 1) Then Cows = Cows + 1
                    End If
                End If
            Next i
            Poss = collSoluces.Count
            Debug.Print "Bulls : " & NbBulls & ", Cows : " & Cows
            If Poss = 1 Then Exit For
        Next
                Debug.Print "---------- THE END ------------"
        Debug.Print "TOSS WAS : " & StrConv(strNumber, vbUnicode) & " We found : " & StrConv(Soluce, vbUnicode)
End Sub

Function CreateNb(NbDigits As Byte) As String
Dim myColl As New Collection
Dim strTemp As String
Dim bytAlea As Byte

    Randomize
    Do
        bytAlea = Int((Rnd * 9) + 1)
        On Error Resume Next
        myColl.Add CStr(bytAlea), CStr(bytAlea)
        If Err <> 0 Then
            On Error GoTo 0
        Else
            strTemp = strTemp & CStr(bytAlea)
        End If
    Loop While Len(strTemp) < NbDigits
    CreateNb = strTemp
End Function

Function CollOfPossibleNumbers() As Collection
Dim TempColl As New Collection
Dim x As String
Dim i As Long
Dim Flag As Boolean
Dim b As Byte

    For i = 1234 To 9876
        Flag = False
        For b = 1 To 4
            x = CStr(i)
            If Len(Replace(x, Mid(x, b, 1), "")) < 3 Then
                Flag = True: Exit For
            End If
        Next
        If Not Flag Then TempColl.Add x, x
    Next i
    Set CollOfPossibleNumbers = TempColl
End Function

Function IsBull(strgNb As String, Digit As String, place As Byte) As Boolean
    IsBull = (Mid(strgNb, place, 1) = Digit)
End Function

Function IsCow(C As Collection, strgNb As String, Digit As String, place As Byte) As Boolean
    If (InStr(strgNb, Digit) > 0) Then
        IsCow = True: place = InStr(strgNb, Digit)
        RemoveIfNotCow C, Digit
    End If
End Function

Sub RemoveIfNotBull(C As Collection, Digit As String, place As Byte)
Dim E As Variant

    For Each E In C
        If Mid(E, place, 1) <> Digit Then C.Remove E
    Next
End Sub

Sub RemoveIfNotCow(C As Collection, Digit As String)
Dim E As Variant

    For Each E In C
        If (InStr(E, Digit) = 0) Then C.Remove E
    Next
End Sub
