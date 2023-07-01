Function Real2Rational(r As Double, bound As Long) As String

If r = 0 Then
    Real2Rational = "0/1"
ElseIf r < 0 Then
    Result = Real2Rational(-r, bound)
    Real2Rational = "-" & Result
Else
    best = 1
    bestError = 1E+99
    For i = 1 To bound + 1
        currentError = Abs(i * r - Round(i * r))
        If currentError < bestError Then
            best = i
            bestError = currentError
            If bestError < 1 / bound Then GoTo SkipLoop
        End If
    Next i
SkipLoop:
    Real2Rational = Round(best * r) & "/" & best
End If
End Function

Sub TestReal2Rational()
Debug.Print "0.75" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(0.75, CLng(Order));
Next i
Debug.Print

Debug.Print "0.518518" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(0.518518, CLng(Order));
Next i
Debug.Print

Debug.Print "0.9054054" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(0.9054054, CLng(Order));
Next i
Debug.Print

Debug.Print "0.142857143" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(0.142857143, CLng(Order));
Next i
Debug.Print

Debug.Print "3.141592654" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(3.141592654, CLng(Order));
Next i
Debug.Print

Debug.Print "2.718281828" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(2.718281828, CLng(Order));
Next i
Debug.Print

Debug.Print "-0.423310825" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(-0.423310825, CLng(Order));
Next i
Debug.Print

Debug.Print "31.415926536" & ":";
For i = 0 To 5
    Order = CDbl(10) ^ CDbl(i)
    Debug.Print " " & Real2Rational(31.415926536, CLng(Order));
Next i
End Sub
