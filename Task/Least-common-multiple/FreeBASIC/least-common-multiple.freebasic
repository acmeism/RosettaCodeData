' FB 1.05.0 Win64

Function lcm (m As Integer, n As Integer) As Integer
  If m = 0 OrElse n = 0 Then Return 0
  If m < n Then Swap m, n '' to minimize iterations needed
  Var count = 0
  Do
    count +=1
  Loop Until (m * count) Mod n  = 0
  Return m * count
End Function

Print "lcm(12, 18) ="; lcm(12, 18)
Print "lcm(15, 12) ="; lcm(15, 12)
Print "lcm(10, 14) ="; lcm(10, 14)
Print
Print "Press any key to quit"
Sleep
