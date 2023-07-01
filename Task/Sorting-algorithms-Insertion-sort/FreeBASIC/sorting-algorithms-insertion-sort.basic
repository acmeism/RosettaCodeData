' version 20-10-2016
' compile with: fbc -s console
' for boundry checks on array's compile with: fbc -s console -exx

Sub insertionSort( arr() As Long )

  ' sort from lower bound to the highter bound
  ' array's can have subscript range from -2147483648 to +2147483647

  Dim As Long lb = LBound(arr)
  Dim As Long i, j, value

  For i = lb +1 To UBound(arr)

    value = arr(i)
    j = i -1
    While j >= lb  And arr(j) > value
      arr(j +1) = arr(j)
      j = j -1
    Wend

    arr(j +1) = value

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
insertionSort(array())  ' sort the array
Print "  sort ";
For i = a To b : Print Using "####"; array(i); : Next : Print


' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
