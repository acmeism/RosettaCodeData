'Arithmetic - Integer
Sub RosettaArithmeticInt()
Dim opr As Variant, a As Integer, b As Integer
On Error Resume Next

a = CInt(InputBox("Enter first integer", "XLSM | Arithmetic"))
b = CInt(InputBox("Enter second integer", "XLSM | Arithmetic"))

Debug.Print "a ="; a, "b="; b, vbCr
For Each opr In Split("+ - * / \ mod ^", " ")
    Select Case opr
        Case "mod":     Debug.Print "a mod b", a; "mod"; b, a Mod b
        Case "\":       Debug.Print "a \ b", a; "\"; b, a \ b
        Case Else:      Debug.Print "a "; opr; " b", a; opr; b, Evaluate(a & opr & b)
    End Select
Next opr
End Sub
