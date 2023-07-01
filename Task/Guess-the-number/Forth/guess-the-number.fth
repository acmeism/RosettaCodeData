\ tested with GForth  0.7.0
: RND    ( -- n) TIME&DATE 2DROP 2DROP DROP 10 MOD ;         \ crude random number
: ASK    ( -- ) CR ." Guess a number between 1 and 10? " ;
: GUESS  ( -- n)  PAD DUP 4 ACCEPT EVALUATE ;
: REPLY  ( n n' -- n)  2DUP <> IF CR ." No, it's not " DUP . THEN ;

: GAME ( -- )
          RND
          BEGIN   ASK GUESS REPLY  OVER =  UNTIL
          CR ." Yes it was " .
          CR ." Good guess!"  ;
