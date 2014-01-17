Sub Rosetta_AB()
Dim stEval As String
stEval = InputBox("Enter two numbers, separated only by a space", "Rosetta Code", "2 2")
MsgBox "You entered " & stEval & vbCr & vbCr & _
    "VBA converted this input to " & Replace(stEval, " ", "+") & vbCr & vbCr & _
    "And evaluated the result as " & Evaluate(Replace(stEval, " ", "+")), vbInformation + vbOKOnly, "XLSM"
End Sub
