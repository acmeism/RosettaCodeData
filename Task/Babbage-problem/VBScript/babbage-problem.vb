'Sir, this is a script that could solve your problem.

'Lines that begin with the apostrophe are comments. The machine ignores them.

'The next line declares a variable n and sets it to 0. Note that the
'equals sign "assigns", not just "relates". So in here, this is more
'of a command, rather than just a mere proposition.
n = 0

'Starting from the initial value, which is 0, n is being incremented
'by 1 while its square, n * n (* means multiplication) does not have
'a modulo of 269696 when divided by one million. This means that the
'loop will stop when the smallest positive integer whose square ends
'in 269696 is found and stored in n. Before I forget, "<>" basically
'means "not equal to".
Do While ((n * n) Mod 1000000) <> 269696
    n = n + 1 'Increment by 1.
Loop

'The function "WScript.Echo" displays the string to the monitor. The
'ampersand concatenates strings or variables to be displayed.
WScript.Echo("The smallest positive integer whose square ends in 269696 is " & n & ".")
WScript.Echo("Its square is " & n*n & ".")

'End of Program.
