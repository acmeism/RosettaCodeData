36000 CONSTANT #DIGITS  \ Enough for !10000
CREATE S #DIGITS ALLOT  S #DIGITS ERASE  VARIABLE S#
CREATE F #DIGITS ALLOT  F #DIGITS ERASE  VARIABLE F#
1 F C!  1 F# !  \ F = 1 = 0!

\ "Bignums": represented by two cells on the stack:
\ 1) An address pointing to the least-significant unit
\ 2) An integer size representing the number of character-size units
: mod/   /mod swap ;
: B+ ( addr u addr' u' -- u'')  \ Add the second "bignum" into the first
   over + >R  -rot over + >R ( addr' addr R:end' R:end)
   swap >R 0 over R>  ( addr 0 addr addr' R:end' R:end)
   \ 0: Assume second has equal or more digits, as in our problem
   BEGIN over R@ < WHILE  \ 1: add all digits from S
     dup >R C@ swap dup >R C@ ( addr c a a' R:end' R:end R:addr'* R:addr*)
     + +  10 mod/ R@ C!  R> 1+ R> 1+
   REPEAT R> drop  ( addr c addr* addr'* R:end')
   BEGIN dup R@ < WHILE   \ 2: add any remaining digits from F
     dup >R C@ swap >R        ( addr c a' R:end' R:addr'* R:addr*)
     +    10 mod/ R@ C!  R> 1+ R> 1+
   REPEAT R> drop drop  ( addr c addr*)
   BEGIN over WHILE       \ 3: add any carry digits
     >R 10 mod/ ( addr m d R:addr*) R@ C! R> 1+
   REPEAT  rot - nip ;  \ calculate travel distance, discard 0 carry
: B* ( addr u u' -- u'')  \ Multiply "bignum" inplace by U'
   0 2swap over >R dup >R bounds  ( u' 0 addr+u addr R:addr R:u)
   DO ( u' c) over I C@ * +  10 mod/ I C! LOOP
   nip R> BEGIN ( c u) over WHILE  \ insert carry, may have multiple digits
     >R  10 mod/  R@ swap R> R@ + ( m u d addr+u R:addr) C!  1+
   REPEAT  nip R> ( u'' addr) drop ;
: .B ( addr u)  over +  BEGIN 1-  \ print bignum
     dup C@ [char] 0 + EMIT  over over >=
   UNTIL  drop drop ;
: .!n   0 <# #s [char] ! hold #> 6 over - spaces type space ;
: REPORT ( n)
   dup 10 <=  over dup  20 111 within  swap 10 mod 0= and or
   IF .!n [char] = emit space S S# @ .B cr
   ELSE dup 1000 mod 0=
     IF .!n ." has " S# @ . ." digits" cr
     ELSE drop THEN
   THEN ;
: GO   0 REPORT
   1 BEGIN dup 10000 <=
   WHILE
     S S# @  F F# @      B+ S# !
     dup REPORT
     dup     F F# @  rot B* F# !
   1+ REPEAT  drop ;
