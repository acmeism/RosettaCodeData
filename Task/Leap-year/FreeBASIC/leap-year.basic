' version 23-06-2015
' compile with: fbc -s console

#Ifndef TRUE        ' define true and false for older freebasic versions
    #Define FALSE 0
    #Define TRUE Not FALSE
#EndIf

Function leapyear(Year_ As Integer) As Integer

    If (Year_ Mod 4) <> 0 Then Return FALSE
    If (Year_ Mod 100) = 0 AndAlso (Year_ Mod 400) <> 0 Then Return FALSE
    Return TRUE

End Function

' ------=< MAIN >=------

' year is a FreeBASIC keyword
Dim As Integer Year_

For Year_ = 1800 To 2900 Step 100
    Print Year_; IIf(leapyear(Year_), " is a leap year", " is not a leap year")
Next

Print : Print

For Year_ = 2012 To 2031
    Print Year_;
    If leapyear(Year_) = TRUE Then
        Print " = leap",
    Else
        Print " = no",
    End If
    If year_ Mod 4 = 3 Then Print ' lf/cr
Next

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
