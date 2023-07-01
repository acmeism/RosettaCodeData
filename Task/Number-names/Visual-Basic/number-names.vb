Option Explicit

Private small As Variant, tens As Variant, big As Variant

Sub Main()
    small = Array("one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", _
                  "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", _
                  "eighteen", "nineteen")
    tens = Array("twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety")
    big = Array("thousand", "million", "billion")

    Dim tmpInt As Long
    tmpInt = Val(InputBox("Gimme a number!", "NOW!", Trim$(Year(Now)) & IIf(Month(Now) < 10, "0", "") & _
                 Trim$(Month(Now)) & IIf(Day(Now) < 10, "0", "") & Trim$(Day(Now))))
    MsgBox int2Text$(tmpInt)
End Sub

Function int2Text$(number As Long)
    Dim num As Long, outP As String, unit As Integer
    Dim tmpLng1 As Long

    If 0 = number Then
        int2Text$ = "zero"
        Exit Function
    End If

    num = Abs(number)

    Do
        tmpLng1 = num Mod 100
        Select Case tmpLng1
            Case 1 To 19
                outP = small(tmpLng1 - 1) + " " + outP
            Case 20 To 99
                Select Case tmpLng1 Mod 10
                    Case 0
                        outP = tens((tmpLng1 \ 10) - 2) + " " + outP
                    Case Else
                        outP = tens((tmpLng1 \ 10) - 2) + "-" + small(tmpLng1 Mod 10) + " " + outP
                End Select
        End Select

        tmpLng1 = (num Mod 1000) \ 100
        If tmpLng1 Then
            outP = small(tmpLng1 - 1) + " hundred " + outP
        End If

        num = num \ 1000
        If num < 1 Then Exit Do

        tmpLng1 = num Mod 1000
        If tmpLng1 Then outP = big(unit) + " " + outP

        unit = unit + 1
    Loop

    If number < 0 Then outP = "negative " & outP

    int2Text$ = Trim$(outP)
End Function
