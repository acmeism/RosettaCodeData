' version 26-01-2019
' compile with: fbc -s console

Dim As UByte used()
Dim As Integer sum, temp
Dim As UInteger n, max, count, i

max = 1000 : ReDim used(max)

Print "The first 15 terms are 0";

For n = 0 To 14
    temp = sum - n
    If temp < 1 OrElse used(temp) = 1 Then
        temp = sum + n
    End If
    If temp <= max Then used(temp) = 1
    sum = temp
    Print sum;
Next


sum = 0 : max = 1000 : ReDim used(max)
Print : Print

For n = 0 To 50
    temp = sum - n
    If temp < 1 OrElse used(temp) = 1 Then
        temp = sum + n
    End If
    If used(temp) = 1 Then
        Print "First duplicated number is a(" + Str(n) + ")"
        Exit For
    End If
    If temp <= max Then used(temp) = 1
    sum = temp
Next


sum = 0 : max = 2000000 : ReDim used(max)
Print : Print

For n = 0 To max
    temp = sum - n
    If temp < 1 OrElse used(temp) = 1 Then
        temp = sum + n
    End If
    If temp <= max Then used(temp) = 1
    If i = temp Then
        While used(i) = 1
            i += 1
            If i > 1000 Then
                Exit For
            End If
        Wend
    End If
    sum = temp
    count += 1
Next

Print "All integers from 0 to 1000 are generated in " & count & " terms"
Print

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
