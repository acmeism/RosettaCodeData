\ produces number of one bits in given word...
: numbts ( u -- u ) \ pop count number of bits...
   0 SWAP BEGIN DUP 0<> WHILE SWAP 1+ SWAP DUP 1- AND REPEAT DROP ;

\ constants for variable 32/64 etc. CELL size...
1 CELLS 3 LSHIFT 1- CONSTANT CellMsk
CellMsk numbts CONSTANT CellShft

CREATE bits 8 ALLOT \ bit position Look Up Table...
: mkbts 8 0 DO 1 I LSHIFT I bits + c! LOOP ; mkbts

\ test bit index composites array for prime...
: prime? ( u addr -- ? )
    OVER 3 RSHIFT + C@ SWAP 7 AND bits + C@ AND 0= ;

\ given square index and prime index, u0, sieve the multiples of said prime...
: cullpi! ( u addr u u0 -- u addr u0 )
   DUP DUP + 3 + ROT 4 PICK SWAP \ -- numv addr i prm numv sqri
   DO I 3 RSHIFT 3 PICK + DUP C@ I 7 AND bits + C@ OR SWAP C! DUP +LOOP
   DROP ;

\ initializes sieve storage and parameters
\ given sieve limit, returns bit limit and buffer address ..
: initsieve ( u -- u a-addr )
   3 - \ test limit...
   DUP 0< IF 0 ELSE \ return if number of bits is <= 0!
      1 RSHIFT 1+ \ finish conbersion to number of bits
      DUP 1- CellShft RSHIFT 1+ \ round up to even number of cells
      CELLS DUP ALLOCATE 0= IF DUP ROT ERASE \ set cells0. to zero
      ELSE ABORT" Memory allocation error!!!"
      THEN
   THEN ;

\ pass through sieving to given index in given buffer address as side effect...
: sieve ( u a-addr -- u a-addr )
   0 \ initialize test index i -- numv bufa i
   BEGIN \ test prime square index < limit
      DUP DUP DUP + SWAP 3 + * 3 + TUCK 4 PICK SWAP > \ sqri = 2*i * (I+3) + 3
   WHILE \ -- numv bufa sqri i
      DUP 3 PICK prime? IF cullpi! \ -- numv bufa i
      ELSE SWAP DROP THEN 1+ \ -- numv bufa ni
   REPEAT 2DROP ; \ -- numv bufa; drop sqri i

\ prints already found primes from sieved array...
: .primes ( u a-addr -- )
   SWAP CR ." Primes to " DUP DUP + 2 + 2 MAX . ." are:  "
   DUP 0< IF 1+ 0< IF ." none." ELSE 2 . THEN DROP \ case no primes or just 2
   ELSE 2 . 0 DO I OVER prime? IF I I + 3 + . THEN LOOP FREE DROP
   THEN ;

\ pop count style Look Up Table by 16 bits entry;
\ is a 65536 byte array containing number of zero bits for each index...
CREATE cntLUT16 65536 ALLOT
: mkpop ( u -- u )   numbts 16 SWAP - ;
: initLUT ( -- )   cntLUT16 65536 0 DO I mkpop OVER I + C! LOOP DROP ; initLUT
: popcount@ ( u -- u )
   0 1 CELlS 1 RSHIFT 0
   DO OVER 65535 AND cntLUT16 + C@ + SWAP 16 RSHIFT SWAP LOOP SWAP DROP ;

\ count number of zero bits up to given bits index-1 in array address;
\ params are number of bits used - bits, negative indicates <2/2 out: 0/1,
\ given address is of the allocated bit buffer - bufa;
\ values used: bmsk is bit mask to limit bit in last cell,
\ lci is cell index of last cell used, cnt is the return value...
\ NOTE. this is for little-endian; big-endian needs a byte swap
\ before the last mask and popcount operation!!!
: primecount@ ( u a-addr -- u )
   LOCALS| bufa numb |
   numb 0< IF numb 1+ 0< IF 0 ELSE 1 THEN \ < 3 -> <2/2 -> 0/1!
   ELSE
      numb 1- TO numb \ numb -= 1
      1 \ initial count
      numb CellShft RSHIFT CELLS TUCK \ lci = byte index of CELL including numv
      0 ?DO bufa I + @ popcount@ + 1 CELLS +LOOP \ -- lci cnt
      SWAP bufa + @ \ -- cnt lstCELL
      -2 numb CellMsk AND LSHIFT OR \ bmsk for last CELL -- cnt mskdCELL
      popcount@ + \ add popcount of last masked CELL -- cnt
      bufa FREE DROP \ free bufa -- bmsk cnt lastcell@
   THEN ;

: .countprimesto ( u -- u )
   dup initsieve sieve primecount@
   CR ." There are " . ." primes Up to the " . ." limit." ;

100 initsieve sieve .primes
1000000000 .countprimesto
