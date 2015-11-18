require random.fs

: d5 5 random 1+ ;
: discard? 5 = swap 1 > and ;
: d7
   begin d5 d5 2dup discard? while 2drop repeat
   1- 5 * + 1- 7 mod 1+ ;
