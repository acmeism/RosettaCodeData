import: console

: guessNumber(a, b)
| n g |
   b a - rand a + 1- ->n
   begin
      "Guess a number between" . a . "and" . b . ":" .
      while(System.Console askln asInteger dup -> g isNull) [ "Not a number " println ]
      g n == ifTrue: [ "You found it !" .cr return ]
      g n <  ifTrue: [ "Less" ] else: [ "Greater" ] . "than the target" .cr
   again ;
