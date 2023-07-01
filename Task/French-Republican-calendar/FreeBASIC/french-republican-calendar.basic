' version 18 Pluviose 227
' compile with: fbc -s console
' retained the original comments for then BBC BASIC entry

#Macro rep_leap (_year)
    ' see comment at the beginning of rep_to_day
    ((_year +1) Mod 4 = 0 And ((_year +1) Mod 100 <> 0 Or (_year +1) Mod 400 = 0))
#EndMacro

#Macro gre_leap (_year)
    (_year Mod 4 = 0 And (_year Mod 100 <> 0 Or _year Mod 400 = 0))
#EndMacro

Dim Shared As UInteger gregorian(11) => {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
Dim Shared As String gregorian_s(11), republican(11), sanscolottides(5)
' 7-bit ASCII encoding, so no accents on French words
Data "January", "February", "March", "April", "May", "June"
Data "July", "August", "September", "October", "November", "December"
Data "Vendemiaire", "Brumaire", "Frimaire","Nivose", "Pluviose", "Ventose"
Data "Germinal", "Floreal", "Prairial", "Messidor", "Thermidor", "Fructidor"
Data "Fete de la Vertu", "Fete du Genie", "Fete du Travail", "Fete de l'Opinion"
Data "Fete des Recompenses","Fete de la Revolution"
Restore
For i As UInteger = 0 To 11
    Read gregorian_s(i)
Next
For i As UInteger = 0 To 11
    Read republican(i)
Next
For i As UInteger = 0 To 5
    Read sanscolottides(i)
Next

Sub split(s As String, ByRef d As UInteger, ByRef m As UInteger, ByRef y As UInteger)

    Dim As String month_and_year, Month
    Dim As UInteger i

    s = LCase(Trim(s)) : d = 0 : m = 0 : y = 0
    If Left(s,4) = "fete" Then
        m = 13
        For i = 0 To 5
            If Left(s, Len(sanscolottides(i))) = LCase(sanscolottides(i)) Then
                d = i +1
                y = Val(Right(s, Len(s) - Len(sanscolottides(i)) -1))
            End If
        Next
    Else
        d = Val(Left(s, InStr(s, " ") -1))
        month_and_year = Mid(s, InStr(s, " ") +1)
        Month = Left(month_and_year, InStr(month_and_year, " ") -1)
        y = Val(Mid(month_and_year, InStr(month_and_year, " ") +1))
        If y < 1792 Then
            For i = 0 To 11
                If LCase(republican(i)) = Month Then m = i +1
            Next
        Else
            For i = 0 To 11
                If LCase(gregorian_s(i)) = Month Then m = i +1
            Next
        End If
    End If

End Sub

Sub day_to_gre(Day As UInteger, ByRef d As UInteger, ByRef m As UInteger, ByRef y As UInteger)

    y = Fix(Day / 365.25)
    d = Day - Fix(365.25 * y) + 21
    y += 1792
    d += y \ 100 - y \ 400 - 13
    m = 8

    While d > gregorian(m)
        d -= gregorian(m)
        m += 1
        If m = 12 Then
            m = 0
            y += 1
            If gre_leap(y) Then gregorian(1) = 29 Else gregorian(1) = 28
        End If
    Wend
    gregorian(1) = 28
    m += 1

End Sub

Function gre_to_day(d As UInteger, m As UInteger, y As UInteger) As UInteger

    ' modified & repurposed from code given at
    ' https://www.staff.science.uu.nl/~gent0113/calendar/isocalendar_text5.htm

    If m < 3 Then
        y -= 1
        m += 12
    End If
    Return Fix(365.25 * y) - y \ 100 + y \ 400 + Fix(30.6 * (m +1)) + d - 654842

End Function

Function rep_to_day(d As UInteger, m As UInteger, y As UInteger) As UInteger

    ' assume that a year is a leap year iff the _following_ year is
    ' divisible by 4, but not by 100 unless also by 400
    '
    ' other methods for computing republican leap years exist

    If m = 13 Then
        m -= 1
        d += 30
    End If
    If rep_leap(y) Then d -= 1

    Return 365 * y + (y +1) \ 4 - (y +1) \ 100 + (y +1) \ 400 + 30 * m + d - 395

End Function

Sub day_to_rep(Day As UInteger, ByRef d As UInteger, ByRef m As UInteger, ByRef y As UInteger)

    Dim As UInteger sansculottides = 5

    y = Fix(Day / 365.25)
    If rep_leap(y) Then y -= 1
    d = Day - Fix(365.25 * y) + (y +1) \ 100 - (y +1) \ 400
    y += 1
    m = 1
    If rep_leap(y) Then sansculottides = 6
    While d > 30
        d -= 30
        m += 1
        If m = 13 Then
            If d > sansculottides Then
                d -= sansculottides
                m = 1
                y += 1
                If rep_leap(y) Then sansculottides = 6 Else sansculottides = 5
            End If
        End If
    Wend

End Sub

' ------=< main >=------

Dim As UInteger Day, Month, Year
Dim As String src

Print "*** French  Republican ***"
Print "*** calendar converter ***"
Print "Enter a date to convert, in the format 'day month year'"
Print "e.g.: 1 Prairial 3,"
Print "      20 May 1795."
Print "For Sansculottides, use 'day year'"
Print "e.g.: Fete de l'opinion 9."
Print "Or just press 'RETURN' to exit the program."
Print

Do
    Line Input "> ", src
    If src <> "" Then
        split(src, Day, Month, Year)
        If Day = 0 Or Month = 0 Or Year <= 0 Then
            Print "Error in input"
            Continue Do
        End If
        ' for simplicity, we assume that years up to 1791 are republican
        ' and years from 1792 onwards are gregorian
        If Year < 1792 Then
            ' convert republican date to number of days elapsed
            ' since 21 september 1792, then convert that number
            ' to the gregorian date
            day_to_gre(rep_to_day(Day, Month, Year),Day, Month, Year)
            Print; Day; " "; gregorian_s(Month -1); " "; Year
        Else
            ' convert gregorian date to republican, via
            ' number of days elapsed since 21 september 1792
            day_to_rep(gre_to_day(Day, Month, Year), Day, Month, Year)
            If Month = 13 Then
                Print sanscolottides(Day -1); " "; Year
            Else
                Print ; Day; " "; republican(Month -1); " "; Year
            End If
        End If
    End If
Loop Until src = ""

End
