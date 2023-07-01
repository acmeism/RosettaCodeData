' version 05-07-2015
' compile with: fbc -s console

#Ifndef TRUE        ' define true and false for older freebasic versions
    #Define FALSE 0
    #Define TRUE Not FALSE
#EndIf

Function luhntest(cardnr As String) As Integer

    cardnr = Trim(cardnr) ' we don't want spaces
    Dim As String reverse_nr = cardnr
    Dim As Integer i, j, s1, s2, l = Len(cardnr) - 1

    ' reverse string
    For i = 0 To l
        reverse_nr[i] = cardnr[l - i]
    Next
    ' sum odd numbers
    For i = 0 To l Step 2
        s1 = s1 + (reverse_nr[i] - Asc("0"))
    Next
    ' sum even numbers
    For i = 1 To l Step 2
        j = reverse_nr[i] - Asc("0")
        j = j * 2
        If j > 9 Then j = j Mod 10 + 1
        s2 = s2 + j
    Next

    If (s1 + s2) Mod 10 = 0 Then
        Return TRUE
    Else
        Return FALSE
    End If

End Function

' ------=< MAIN >=------

Dim As String input_nr(1 To ...) = {"49927398716", "49927398717",_
                          "1234567812345678", "1234567812345670"}
Dim As Integer a

Print  "Task test number 49927398716 should be TRUE, report back as ";
Print IIf(luhntest("49927398716" ) = TRUE, "TRUE", "FALSE")
Print : Print

Print "test card nr:"
For a = 1 To UBound(input_nr)
    Print input_nr(a); " = "; IIf(luhntest(input_nr(a)) = TRUE, "TRUE", "FALSE")
Next

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
