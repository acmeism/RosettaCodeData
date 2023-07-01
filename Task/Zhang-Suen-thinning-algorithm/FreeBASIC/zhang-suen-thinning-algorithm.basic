' version 08-10-2016
' compile with: fbc -s console

Data "00000000000000000000000000000000"
Data "01111111110000000111111110000000"
Data "01110001111000001111001111000000"
Data "01110000111000001110000111000000"
Data "01110001111000001110000000000000"
Data "01111111110000001110000000000000"
Data "01110111100000001110000111000000"
Data "01110011110011101111001111011100"
Data "01110001111011100111111110011100"
Data "00000000000000000000000000000000"
Data "END"

' ------=< MAIN >=------

Dim As UInteger x, y, m, n
Dim As String input_str

Do        ' find out how big it is
  Read input_str
  If input_str = "END" Then Exit Do
  If x < Len(input_str) Then x = Len(input_str)
  y = y + 1
Loop

m = x -1 : n = y -1
ReDim As UByte old(m, n), new_(m, n)

y = 0
Restore   ' restore data pointer
Do        ' put data in array
  Read input_str
  If input_str="END" Then Exit Do
  For x = 0 To Len(input_str) -1
    old(x,y) = input_str[x] - Asc("0")
    ' print image
    If old(x, y) = 0 Then Print "."; Else Print "#";
  Next
  Print
  y = y + 1
Loop

'corners and sides do not change
For x = 0 To m
  new_(x, 0) = old(x, 0)
  new_(x, n) = old(x, n)
Next

For y = 0 To n
  new_(0, y) = old(0, y)
  new_(m, y) = old(m, y)
Next

Dim As UInteger tmp, change, stage = 1
Do
  change = 0
  For y = 1 To n -1
    For x = 1 To m -1
      ' -1-
      If old(x,y) = 0 Then ' first condition, p1 must be black
        new_(x,y) = 0
        Continue For
      End If
      ' -2-
      tmp = old(x, y -1) + old(x +1, y -1)
      tmp = tmp + old(x +1, y) + old(x +1, y +1) + old(x, y +1)
      tmp = tmp + old(x -1, y +1) + old(x -1, y) + old(x -1, y -1)
      If tmp < 2 OrElse tmp > 6 Then ' 2 <= B(p1) <= 6
        new_(x, y) = 1
        Continue For
      End If
      ' -3-
      tmp = 0
      If old(x   , y   ) = 0 And old(x   , y -1) = 1 Then tmp += 1  ' p1 > p2
      If old(x   , y -1) = 0 And old(x +1, y -1) = 1 Then tmp += 1  ' p2 > p3
      If old(x +1, y -1) = 0 And old(x +1, y   ) = 1 Then tmp += 1  ' p3 > p4
      If old(x +1, y   ) = 0 And old(x +1, y +1) = 1 Then tmp += 1  ' p4 > p5
      If old(x +1, y +1) = 0 And old(x   , y +1) = 1 Then tmp += 1  ' p5 > p6
      If old(x   , y +1) = 0 And old(x -1, y +1) = 1 Then tmp += 1  ' p6 > p7
      If old(x -1, y +1) = 0 And old(x -1, y   ) = 1 Then tmp += 1  ' p7 > p8
      If old(x -1, y   ) = 0 And old(x -1, y -1) = 1 Then tmp += 1  ' p8 > p9
      If old(x -1, y -1) = 0 And old(x   , y -1) = 1 Then tmp += 1  ' p9 > p2
      ' tmp = 1 ==> A(P1) = 1
      If tmp <> 1 Then
        new_(x, y) = 1
        Continue For
      End If
      If (stage And 1) = 1 Then
        ' step 1 -4- -5-
        If (old(x, y -1) + old(x +1, y) + old(x, y +1)) = 3 OrElse _
           (old(x +1, y) + old(x, y +1) + old(x -1, y)) = 3 Then
          new_(x, y) = 1
          Continue For
        End If
      Else
        ' step 2 -4- -5-
        If (old(x, y -1) + old(x +1, y) + old(x -1, y)) = 3 OrElse _
           (old(x, y -1) + old(x, y +1) + old(x -1, y)) = 3 Then
          new_(x, y) = 1
          Continue For
        End If
      End If
      ' all condition are met, make p1 white (0)
      new_(x, y) = 0
      change = 1 ' flag change
    Next
  Next

  ' copy new_() into old()
  For y = 0 To n
    For x = 0 To m
      old(x, y) = new_(x, y)
    Next
  Next

  stage += 1
Loop Until change = 0 ' stop when there are no changes made

Print ' print result
Print "End result"
For y = 0 To n
  For x = 0 To m
    If old(x, y) = 0 Then Print "."; Else Print "#";
  Next
  Print
Next


' empty keyboard buffer
While Inkey <> "" : Wend
Print : Print "hit any key to end program"
Sleep
End
