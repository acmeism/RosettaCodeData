/*REXX program that plays the guessing (the number) game. */
 low=1                /*lower range for the guessing game.*/
high=100              /*upper range for the guessing game.*/
try=0                 /*number of valid attempts.         */
r=random(1,100)       /*get a random number (low-->high). */

do forever
  say
  say "guess the number, it's between" low 'and' high '(inclusive)',
      'or enter quit to end the game.'
  say
  pull g
  say
  g=space(g)
  Select
    When g='' then iterate
    When g='QUIT' then exit
    When g='?' then Do
      Say 'The number you are looking for is' r
      Iterate
      End
    When \datatype(g,'W') then do
      call ser g "isn't a valid number"
      iterate
      end
    When g<low then do
      call ser g 'is below the lower limit of' low
      iterate
      end
    When g>high then do
      call ser g 'is above the higher limit of' high
      iterate
      end
    When g=r then do
      try=try+1
      Leave
      End
    Otherwise Do
      try=try+1
      if g>r then what='high'
             else what='low'
      say 'your guess of' g 'is too' what'.'
      end
    end
  end

say
tries='tries'
if try=1 then
  say 'Congratulations!, you guessed the number in 1 try. Did you cheat?'
Else
  say 'Congratulations!, you guessed the number in' try 'tries.'
say
exit

ser: say; say '*** error ! ***'; say arg(1); say; return
