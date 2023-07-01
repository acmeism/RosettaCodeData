' version 05-04-2017
' compile with: fbc -s console

' TRUE/FALSE are built-in constants since FreeBASIC 1.04
' But we have to define them for older versions.
#Ifndef TRUE
    #Define FALSE 0
    #Define TRUE Not FALSE
#EndIf

Function farey(n As ULong, descending As Long) As ULong

    Dim As Long a, b = 1, c = 1, d = n, k
    Dim As Long aa, bb, cc, dd, count

    If descending = TRUE Then
        a = 1 : c = n -1
    End If

    count += 1
    If n < 12 Then Print Str(a); "/"; Str(b); " ";

    While ((c <= n) And Not descending) Or ((a > 0) And descending)
        aa = a : bb = b : cc = c : dd = d
        k = (n + b) \ d
        a = cc : b = dd : c = k * cc - aa : d = k * dd - bb
        count += 1
        If n < 12 Then Print Str(a); "/"; Str(b); " ";
    Wend

    If n < 12 Then Print

    Return count

End Function

' ------=< MAIN >=------

For i As Long = 1 To 11
    Print "F"; Str(i); " = ";
    farey(i, FALSE)
Next
Print
For i As Long= 100 To 1000 Step 100
    Print "F";Str(i);
    Print iif(i <> 1000, " ", ""); " = ";
    Print Using "######"; farey(i, FALSE)
Next

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
