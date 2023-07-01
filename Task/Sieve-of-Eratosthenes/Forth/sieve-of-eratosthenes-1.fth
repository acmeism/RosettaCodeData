: prime? ( addr -- ? ) C@ 0= ; \ test composites array for prime

\ given square index and prime index, u0, sieve the multiples of said prime...
: cullpi! ( u addr u u0 -- u addr u0 )
   DUP DUP + 3 + ROT 4 PICK SWAP \ -- numv addr i prm numv sqri
   DO 2 PICK I + TRUE SWAP C! DUP +LOOP DROP ;

\ process for required prime limit; allocate and initialize returned buffer...
: initsieve ( u -- u a-addr)
   3 - DUP 0< IF 0 ELSE
      1 RSHIFT 1+ DUP ALLOCATE 0<> IF ABORT" Memory allocation error!!!"
      ELSE 2DUP SWAP ERASE THEN
   THEN ;

\ pass through sieving to given index in given buffer address as side effect...
: sieve ( u a-addr -- u a-addr )
   0 \ initialize test index i -- numv bufa i
   BEGIN \ test prime square index < limit
      DUP DUP DUP + SWAP 3 + * 3 + TUCK 4 PICK SWAP > \ sqri = 2*i * (I+3) + 3
   WHILE \ -- numv bufa sqri i
      2 PICK OVER + prime? IF cullpi! \ -- numv bufa i
      ELSE SWAP DROP THEN 1+ \ -- numv bufa ni
   REPEAT 2DROP ; \ -- numv bufa; drop sqri i

\ print primes to given limit...
: .primes ( u a-addr -- )
   OVER 0< IF DROP 2 - 0< IF ( ." No primes!" ) ELSE ( ." Prime:  2" ) THEN
   ELSE ." Primes:  2 " SWAP 0
      DO DUP I + prime? IF I I + 3 + . THEN LOOP FREE DROP THEN ;

\ count number of primes found for number odd numbers within
\ given presumed sieved buffer starting at address...
: countprimes@ ( u a-addr -- )
  SWAP DUP 0< IF 1+ 0< IF DROP 0 ELSE 1 THEN
   ELSE 1 SWAP \ -- bufa cnt numv
      0 DO OVER I + prime? IF 1+ THEN LOOP SWAP FREE DROP
   THEN ;

\ shows counted number of primes to the given limit...
: .countprimesto ( u -- )
   DUP initsieve sieve countprimes@
   CR ." Found " . ." primes Up to the " . ." limit." ;

\ testing the code...
100 initsieve sieve .primes
1000000 .countprimesto
