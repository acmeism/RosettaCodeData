' version 17-06-2015
' compile with: fbc -s console

Function hailstone_fast(number As ULongInt) As ULongInt
    ' faster version
    ' only counts the sequence

    Dim As ULongInt count = 1

    While number <> 1
        If (number And 1) = 1 Then
            number += number Shr 1 + 1  ' 3*n+1 and n/2 in one
            count += 2
        Else
            number Shr= 1 ' divide number by 2
            count += 1
        End If
    Wend

    Return count

End Function

Sub hailstone_print(number As ULongInt)
    ' print the number and sequence

    Dim As ULongInt count = 1

    Print "sequence for number "; number
    Print Using "########"; number;   'starting number

    While number <> 1
        If (number And 1) = 1 Then
            number = number * 3 + 1   ' n * 3 + 1
            count += 1
        Else
            number = number \ 2       ' n \ 2
            count += 1
        End If
        Print Using "########"; number;
    Wend

    Print : Print
    Print "sequence length = "; count
    Print
    Print String(79,"-")

End Sub

Function hailstone(number As ULongInt) As ULongInt
    ' normal version
    ' only counts the sequence

    Dim As ULongInt count = 1

    While number <> 1
        If (number And 1) = 1 Then
            number = number * 3 + 1 ' n * 3 + 1
            count += 1
        End If
        number = number \ 2 ' divide number by 2
        count += 1
    Wend

    Return count

End Function

' ------=< MAIN >=------

Dim As ULongInt number
Dim As UInteger x, max_x, max_seq

hailstone_print(27)
Print

For x As UInteger = 1 To 100000
    number = hailstone(x)
    If number > max_seq Then
        max_x = x
        max_seq = number
    End If
Next

Print  "The longest sequence is for "; max_x; ", it has a sequence length of "; max_seq

' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print : Print "hit any key to end program"
Sleep
End
