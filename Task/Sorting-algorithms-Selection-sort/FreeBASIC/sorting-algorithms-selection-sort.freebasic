' version 03-12-2016
' compile with: fbc -s console
' for boundry checks on array's compile with: fbc -s console -exx

Sub selectionsort(arr() As Long)

    ' sort from lower bound to the highter bound
    ' array's can have subscript range from -2147483648 to +2147483647

    Dim As Long i, j, x
    Dim As Long lb = LBound(arr)
    Dim As Long ub = UBound(arr)

    For i = lb To ub -1
        x = i
        For j = i +1 To ub
            If arr(j) < arr(x) Then x = j
        Next
        If x <> i Then
            Swap arr(i), arr(x)
        End If
    Next

End Sub

' ------=< MAIN >=------

Dim As Long i, array(-7 To 7)
Dim As Long a = LBound(array), b = UBound(array)

Randomize Timer
For i = a To b : array(i) = i  : Next
For i = a To b ' little shuffle
    Swap array(i), array(Int(Rnd * (b - a +1)) + a)
Next

Print "unsort ";
For i = a To b : Print Using "####"; array(i); : Next : Print
selectionsort(array())  ' sort the array
Print "  sort ";
For i = a To b : Print Using "####"; array(i); : Next : Print

' empty keyboard buffer
While InKey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
