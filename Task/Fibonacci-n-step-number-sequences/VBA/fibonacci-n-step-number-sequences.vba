Option Explicit

Sub Main()
Dim temp$, T() As Long, i&
    'Fibonacci:
    T = Fibonacci_Step(1, 15, 1)
    For i = LBound(T) To UBound(T)
        temp = temp & ", " & T(i)
    Next
    Debug.Print "Fibonacci: " & Mid(temp, 3)
    temp = ""

    'Tribonacci:
    T = Fibonacci_Step(1, 15, 2)
    For i = LBound(T) To UBound(T)
        temp = temp & ", " & T(i)
    Next
    Debug.Print "Tribonacci: " & Mid(temp, 3)
    temp = ""

    'Tetranacci:
    T = Fibonacci_Step(1, 15, 3)
    For i = LBound(T) To UBound(T)
        temp = temp & ", " & T(i)
    Next
    Debug.Print "Tetranacci: " & Mid(temp, 3)
    temp = ""

    'Lucas:
    T = Fibonacci_Step(1, 15, 1, 2)
    For i = LBound(T) To UBound(T)
        temp = temp & ", " & T(i)
    Next
    Debug.Print "Lucas: " & Mid(temp, 3)
    temp = ""
End Sub

Private Function Fibonacci_Step(First As Long, Count As Long, S As Long, Optional Second As Long) As Long()
Dim T() As Long, R() As Long, i As Long, Su As Long, C As Long

    If Second <> 0 Then S = 1
    ReDim T(1 - S To Count)
    For i = LBound(T) To 0
        T(i) = 0
    Next i
    T(1) = IIf(Second <> 0, Second, 1)
    T(2) = 1
    For i = 3 To Count
        Su = 0
        C = S + 1
        Do While C >= 0
            Su = Su + T(i - C)
            C = C - 1
        Loop
        T(i) = Su
    Next
    ReDim R(1 To Count)
    For i = 1 To Count
        R(i) = T(i)
    Next
    Fibonacci_Step = R
End Function
