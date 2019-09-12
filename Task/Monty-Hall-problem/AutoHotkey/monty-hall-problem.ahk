#SingleInstance, Force
Iterations = 1000
Loop, %Iterations%
{
   If Monty_Hall(1)
      Correct_Change++
   Else
      Incorrect_Change++
   If Monty_Hall(2)
      Correct_Random++
   Else
      Incorrect_Random++
   If Monty_Hall(3)
      Correct_Stay++
   Else
      Incorrect_Stay++
}
Percent_Change := round(Correct_Change / Iterations * 100)
Percent_Stay := round(Correct_Stay / Iterations * 100)
Percent_Random := round(Correct_Random / Iterations * 100)

MsgBox,, Monty Hall Problem, These are the results:`r`n`r`nWhen I changed my guess, I got %Correct_Change% of %Iterations% (that's %Incorrect_Change% incorrect). That's %Percent_Change%`% correct.`r`n`r`nWhen I randomly changed my guess, I got %Correct_Random% of %Iterations% (that's %Incorrect_Random% incorrect). That's %Percent_Random%`% correct.`r`n`r`nWhen I stayed with my first guess, I got %Correct_Stay% of %Iterations% (that's %Incorrect_Stay% incorrect). That's %Percent_Stay%`% correct.
ExitApp

Monty_Hall(Mode) ;Mode is 1 for change, 2 for random, or 3 for stay
{
	Random, guess, 1, 3
	Random, actual, 1, 3
	Random, rand, 1, 2

	show := guess = actual ? guess = 3 ? guess - rand : guess = 1 ? guess+rand : guess + 2*rand - 3 : 6 - guess - actual
	Mode := Mode = 2 ? 2*rand - 1: Mode
	Return, Mode = 1 ?  6 - guess - show = actual : guess = actual
}
