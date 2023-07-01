Function Biorhythm(Birthdate As Date, Targetdate As Date) As String

'Jagged Array
TextArray = Array(Array("up and rising", "peak"), Array("up but falling", "transition"), Array("down and falling", "valley"), Array("down but rising", "transition"))

DaysBetween = Targetdate - Birthdate

positionP = DaysBetween Mod 23
positionE = DaysBetween Mod 28
positionM = DaysBetween Mod 33

'return the positions - just to return something
Biorhythm = CStr(positionP) & "/" & CStr(positionE) & "/" & CStr(positionM)

quadrantP = Int(4 * positionP / 23)
quadrantE = Int(4 * positionE / 28)
quadrantM = Int(4 * positionM / 33)

percentageP = Round(100 * Sin(2 * WorksheetFunction.Pi * (positionP / 23)), 1)
percentageE = Round(100 * Sin(2 * WorksheetFunction.Pi * (positionE / 28)), 1)
percentageM = Round(100 * Sin(2 * WorksheetFunction.Pi * (positionM / 33)), 1)

transitionP = Targetdate + WorksheetFunction.Floor((quadrantP + 1) / 4 * 23, 1) - positionP
transitionE = Targetdate + WorksheetFunction.Floor((quadrantE + 1) / 4 * 28, 1) - positionE
transitionM = Targetdate + WorksheetFunction.Floor((quadrantM + 1) / 4 * 33, 1) - positionM

Select Case True
    Case percentageP > 95
        textP = "Physical day " & positionP & " : " & "peak"
    Case percentageP < -95
        textP = "Physical day " & positionP & " : " & "valley"
    Case percentageP < 5 And percentageP > -5
        textP = "Physical day " & positionP & " : " & "critical transition"
    Case Else
        textP = "Physical day " & positionP & " : " & percentageP & "% (" & TextArray(quadrantP)(0) & ", next " & TextArray(quadrantP)(1) & " " & transitionP & ")"
End Select

Select Case True
    Case percentageE > 95
        textE = "Emotional day " & positionE & " : " & "peak"
    Case percentageE < -95
        textE = "Emotional day " & positionE & " : " & "valley"
    Case percentageE < 5 And percentageE > -5
        textE = "Emotional day " & positionE & " : " & "critical transition"
    Case Else
        textE = "Emotional day " & positionE & " : " & percentageE & "% (" & TextArray(quadrantE)(0) & ", next " & TextArray(quadrantE)(1) & " " & transitionE & ")"
End Select

Select Case True
    Case percentageM > 95
        textM = "Mental day " & positionM & " : " & "peak"
    Case percentageM < -95
        textM = "Mental day " & positionM & " : " & "valley"
    Case percentageM < 5 And percentageM > -5
        textM = "Mental day " & positionM & " : " & "critical transition"
    Case Else
        textM = "Mental day " & positionM & " : " & percentageM & "% (" & TextArray(quadrantM)(0) & ", next " & TextArray(quadrantM)(1) & " " & transitionM & ")"
End Select

Header1Text = "Born " & Birthdate & ", Target " & Targetdate
Header2Text = "Day " & DaysBetween

'Print Result
Debug.Print Header1Text
Debug.Print Header2Text
Debug.Print textP
Debug.Print textE
Debug.Print textM
Debug.Print ""

End Function
