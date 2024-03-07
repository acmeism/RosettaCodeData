: READKEY
  1+ BEGIN
    KEY DUP 27 = ABORT" Bye!"
    48 - 2DUP > OVER 0 > AND IF
      DUP 48 + EMIT CR SWAP DROP EXIT
    THEN DROP
  REPEAT
;
: 21GAME CLS
  0 2 RND 1-
  ." 21 is a two player game." CR
  ." The game is played by choosing a number (1, 2 or 3) to be added to the running total. "
  ." The game is won by the player whose chosen number causes the running total to reach exactly 21."
  ." The running total starts at zero. One player will be the computer."
  BEGIN
    NOT
    CR ." The sum is " OVER . CR
    SWAP OVER IF
      ." How many would you like add?"
      ."  (1-3) " 3 READKEY
    ELSE
      ." It is the computer's turn."
      4 OVER 1- 4 MOD -
      DUP 4 = IF 3 RND 1+ MIN THEN
      DUP CR ." Computer adds " . CR
    THEN + SWAP
  OVER 21 < NOT UNTIL
  CR
  IF ." Congratulations. You win."
  ELSE ." Bad Luck. Computer wins."
  THEN CR DROP
;
