Loop, 100
{
  If (Mod(A_Index, 15) = 0)
    output .= "FizzBuzz`n"
  Else If (Mod(A_Index, 3) = 0)
    output .= "Fizz`n"
  Else If (Mod(A_Index, 5) = 0)
    output .= "Buzz`n"
  Else
    output .= A_Index "`n"
}
FileDelete, output.txt
FileAppend, %output%, output.txt
Run, cmd /k type output.txt
