Option Explicit

Sub Main_Even_Odd()
Dim i As Long

    For i = -50 To 48 Step 7
        Debug.Print i & " : IsEven ==> " & IIf(IsEven(i), "is even", "is odd") _
         & " " & Chr(124) & " IsEven2 ==> " & IIf(IsEven2(i), "is even", "is odd") _
         & " " & Chr(124) & " IsEven3 ==> " & IIf(IsEven3(i), "is even", "is odd") _
         & " " & Chr(124) & " IsEven4 ==> " & IIf(IsEven4(i), "is even", "is odd")
    Next
End Sub

Function IsEven(Number As Long) As Boolean
'Use the even and odd predicates
    IsEven = (WorksheetFunction.Even(Number) = Number)
End Function

Function IsEven2(Number As Long) As Boolean
'Check the least significant digit.
'With binary integers, i bitwise-and 1 equals 0 iff i is even, or equals 1 iff i is odd.
Dim lngTemp As Long
    lngTemp = CLng(Right(CStr(Number), 1))
    If (lngTemp And 1) = 0 Then IsEven2 = True
End Function

Function IsEven3(Number As Long) As Boolean
'Divide i by 2.
'The remainder equals 0 if i is even.
Dim sngTemp As Single
    sngTemp = Number / 2
    IsEven3 = ((Int(sngTemp) - sngTemp) = 0)
End Function

Function IsEven4(Number As Long) As Boolean
'Use modular congruences
    IsEven4 = (Number Mod 2 = 0)
End Function
