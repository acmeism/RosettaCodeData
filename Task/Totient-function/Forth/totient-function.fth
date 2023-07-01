: totient   \ n -- n' ;
  DUP DUP 2 ?DO     ( tot n )
    DUP I DUP * < IF   LEAVE   THEN                     \ for(i=2;i*i<=n;i+=2){
    DUP I MOD 0= IF					\     if(n%i==0){
      BEGIN   DUP I /MOD SWAP 0=   WHILE  ( tot n n/i ) \       while(n%i==0);
        NIP       ( tot n/i )                           \         n/=i;
      REPEAT
      DROP                    ( tot n  )  \ Remove the new n on exit from loop
      SWAP DUP I / - SWAP 	  ( tot' n )        	\       tot-=tot/i;
    THEN
  2 I 2 = + +LOOP    \  If I = 2 add 1 else add 2 to loop index.
  DUP 1 > IF   OVER SWAP / -   ELSE   DROP   THEN ;

: bool.  \ f -- ;
  IF   ." True "   ELSE   ." False"   THEN ;

: count-primes  \ n -- n' ;
  0 SWAP 2 ?DO   I DUP totient 1+ = -   LOOP ;

: challenge  \ -- ;
  CR ."   n   φ    prime" CR
  26 1 DO
    I 3 .r
    I totient DUP 4 .r 4 SPACES
    1+ I = bool. CR
  LOOP CR
  100001 100 DO
    ." Number of primes up to " I 6 .R ."  is " I count-primes 4 .R CR
  I 9 * +LOOP  ;
