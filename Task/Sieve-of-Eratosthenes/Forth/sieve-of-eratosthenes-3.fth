\ CPU L1 and L2 cache sizes in bits; power of 2...
1 17 LSHIFT CONSTANT L1CacheBits
L1CacheBits 8 * CONSTANT L2CacheBits

\ produces number of one bits in given word...
: numbts ( u -- u ) \ pop count number of bits...
   0 SWAP BEGIN DUP 0<> WHILE SWAP 1+ SWAP DUP 1- AND REPEAT DROP ;

\ constants for variable 32/64 etc. CELL size...
1 CELLS 3 LSHIFT 1- CONSTANT CellMsk
CellMsk numbts CONSTANT CellShft

CREATE bits 8 ALLOT \ bit position Look Up Table...
: mkbts 8 0 DO 1 I LSHIFT I bits + c! LOOP ; mkbts

\ initializes sieve buffer storage and parameters
\ given sieve buffer bit size (even number of CELLS), returns buffer address ..
: initSieveBuffer ( u -- a-addr )
   CellShft RSHIFT \ even number of cells
   CELLS ALLOCATE 0<> IF ABORT" Memory allocation error!!!" THEN ;

\ test bit index composites array for prime...
: prime? ( u addr -- ? )
    OVER 3 RSHIFT + C@ SWAP 7 AND bits + C@ AND 0= ;

\ given square index and prime index, u0, as sell as bitsz,
\ sieve the multiples of said prime leaving prime index on the stack...
: cullpi! ( u u0 u u addr -- u0 )
   LOCALS| sba bitsz lwi | DUP DUP + 3 + ROT \ -- i prm sqri
   \ culling start incdx address calculation...
   lwi 2DUP > IF - ELSE SWAP - OVER MOD DUP 0<> IF OVER SWAP - THEN
   THEN bitsz SWAP \ -- i prm bitsz strti
   DO I 3 RSHIFT sba + DUP C@ I 7 AND bits + C@ OR SWAP C! DUP +LOOP
   DROP ;

\ cull sieve buffer given base wheel index, bit size,
\ address base prime sieved buffer and
\ the address of the sieve buffer to be culled of composite bits...
: cullSieveBuffer ( u u a-addr a-addr -- )
   >R >R 2DUP + R> R>  \ -- lwi bitsz rngi bpba sba
   LOCALS| sba bpba rngi bitsz lwi |
   bitsz 1- CellShft RSHIFT 1+ CELLS sba SWAP ERASE \ clear sieve buffer
   0 \ initialize base prime index i -- i
   BEGIN \ test prime square index < limit
      DUP DUP DUP + SWAP 3 + * 3 + TUCK rngi < \ sqri = 2*i * (I+3) + 3
   WHILE \ -- sqri i
      DUP bpba prime? IF lwi bitsz sba cullpi! ELSE SWAP DROP THEN \ -- i
   1+ REPEAT 2DROP ; \ --

\ pop count style Look Up Table by 16 bits entry;
\ is a 65536 byte array containing number of zero bits for each index...
CREATE cntLUT16 65536 ALLOT
: mkpop ( u -- u )   numbts 16 SWAP - ;
: initLUT ( -- )   cntLUT16 65536 0 DO I mkpop OVER I + C! LOOP DROP ; initLUT
: popcount@ ( u -- u )
   0 1 CELlS 1 RSHIFT 0
   DO OVER 65535 AND cntLUT16 + C@ + SWAP 16 RSHIFT SWAP LOOP SWAP DROP ;

\ count number of zero bits up to given bits index in array address...
: countSieveBuffer@ ( u a-addr -- u )
   LOCALS| bufa lmti |
   0 \ initial count -- cnt
   lmti CellShft RSHIFT CELLS TUCK \ lci = byte index of CELL including numv
   0 ?DO bufa I + @ popcount@ + 1 CELLS +LOOP \ -- lci cnt
   SWAP bufa + @ \ -- cnt lstCELL
   -2 lmti CellMsk AND LSHIFT OR \ bmsk for last CELL -- cnt mskdCELL
   popcount@ + ; \ add popcount of last masked CELL -- cnt

\ prints found primes from series of culled sieve buffers...
: .primes ( u -- )
   DUP CR ." Primes to " . ." are:  "
   DUP 3 - 0< IF DUP 2 - 0< IF ." none." ELSE 2 . THEN \ <2/2 -> 0/1
   ELSE 2 .
      3 - 1 RSHIFT 1+ \ -- rngi
      DUP 1- L2CacheBits / L2CacheBits * 3 RSHIFT \ -- rng rngi pglmtbytes
      L1CacheBits initSieveBuffer \ address of base prime sieve buffer
      L2CacheBits initSieveBuffer \ address of main sieve buffer
      LOCALS| sba bpsba pglmt | \ local variables -- rngi
      0 OVER L1CacheBits MIN bpsba bpsba cullSieveBuffer
      pglmt 0 ?DO
         I L2CacheBits bpsba sba cullSieveBuffer
         I L2CacheBits 0 DO I sba prime? IF DUP I + DUP + 3 + . THEN LOOP DROP
      L2CacheBits +LOOP \ rngi
      L2CacheBits mod DUP 0> IF \ one more page!
         pglmt DUP L2CacheBits bpsba sba cullSieveBuffer
         SWAP 0 DO I sba prime? IF DUP I + DUP + 3 + . THEN LOOP DROP
      THEN bpsba FREE DROP sba FREE DROP
   THEN ; \ --

\ prints count of found primes from series of culled sieve buffers...
: .countPrimesTo ( u -- )
   DUP 3 - 0< IF 2 - 0< IF 0 ELSE 1 THEN \ < 3 -> <2/2 -> 0/1!
   ELSE
      DUP 3 - 1 RSHIFT 1+
      DUP 1- L2CacheBits / L2CacheBits * \ -- rng rngi pglmtbytes
      L1CacheBits initSieveBuffer \ address of base prime sieve buffer
      L2CacheBits initSieveBuffer \ address of main sieve buffer
      LOCALS| sba bpsba pglmt | \ local variables -- rng rngi
      0 OVER L1CacheBits MIN bpsba bpsba cullSieveBuffer
      1 pglmt 0 ?DO
         I L2CacheBits bpsba sba cullSieveBuffer
         L2CacheBits 1- sba countSieveBuffer@ +
      L2CacheBits +LOOP \ rng rngi cnt
      SWAP L2CacheBits mod DUP 0> IF \ one more page!
         pglmt OVER bpsba sba cullSieveBuffer
         1- sba countSieveBuffer@ + \ partial count!
      THEN
      bpsba FREE DROP sba FREE DROP \ -- range cnt
   THEN CR ." There are " . ." primes Up to the " . ." limit." ;

100 .primes
1000000000 .countPrimesTo
