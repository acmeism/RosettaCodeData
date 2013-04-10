Gui, Add, Edit, r20
Gui,Show
Loop, 100
  Send, % (!Mod(A_Index, 15) ? "FizzBuzz" : !Mod(A_Index, 3) ? "Fizz" : !Mod(A_Index, 5) ? "Buzz" : A_Index) "`n"
Return
Esc::
ExitApp
