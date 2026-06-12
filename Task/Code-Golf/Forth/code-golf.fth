CR ." Code Golf" CR    \ 20 bytes with need to type return key

3313297 2532384 58 BASE ! CR . . CR  \ 36 bytes
DECIMAL                              \ +8 to restore 'normal' behaviour

[0] [IF]                   \ Commented version
  3313297 2532384 		   \ Two integers  base 58 Golf Code
  58 BASE ! 			   \ Change to base 58.
  CR . . CR                \ Print the two integers in base 58
  DECIMAL                  \ Restore the normal base, HEX would be shorter.
[THEN]

