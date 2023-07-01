: stern ( n -- x : return N'th item of Stern-Brocot sequence)
  dup 2 >= if
      2 /mod swap if
         dup 1+ recurse
         swap recurse
         +
      else
         recurse
      then
  then
;

: first ( n -- x : return X such that stern X = n )
  1 begin over over stern <> while 1+ repeat
  swap drop
;

: gcd ( a b -- a gcd b )
  begin swap over mod dup 0= until drop
;

: task
  ( Print first 15 numbers )
  ." First 15: " 1 begin dup stern . 1+ dup 15 > until
  drop cr

  ( Print first occurrence of 1..10 )
  1 begin
      ." First " dup . ." at " dup first .
      1+ cr
  dup 10 > until
  drop

  ( Print first occurrence of 100 )
  ." First 100 at " 100 first . cr

  ( Check that the GCD of each adjacent pair up to 1000 is 1 )
  -1 2 begin
     dup stern over 1- stern gcd 1 =
     rot and swap
     1+
  dup 1000 > until
  swap if
     ." All GCDs are 1."
     drop
  else
     ." GCD <> 1 at: " .
  then
  cr
;

task
bye
