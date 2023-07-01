: is-prime?   \ n -- f ;    \ Fast enough for this application
  DUP 1 AND IF  \ n is odd
    DUP 3 DO
      DUP I DUP * < IF   DROP -1 LEAVE   THEN  \ Leave loop if I**2 > n
      DUP I MOD 0=  IF   DROP  0 LEAVE   THEN  \ Leave loop if n%I is zero
    2 +LOOP  \ iterate over odd I only
  ELSE          \ n is even
    2 =         \ Returns true if n == 2.
  THEN ;

: 1digit    \ -- ;    \ Select and print one digit numbers which are prime
  10 2 ?DO
    I is-prime? IF   I 9 .r   THEN
  LOOP ;

: 2digit  \ n-bfwd digit  -- ;
  \ Generate and print primes where least significant digit < digit
  \ n-bfwd is the base number bought foward from calls to `digits` below.
  SWAP 10 * SWAP 1 ?DO
    DUP I + is-prime? IF   DUP I + 9 .r   THEN
  2 I 3 = 2* - +LOOP DROP ;  \ This generates the I sequence 1 3 7 9

: digits  \ #digits n-bfwd max-digit -- ;
  \ Print descendimg primes with #digits digits.
  2 PICK 9 > IF   ." #digits must be less than 10." 2DROP DROP EXIT   THEN
  2 PICK 1 = IF   2DROP DROP 1digit EXIT   THEN    \ One digit is special simple case
  2 PICK 2 = IF                                    \ Two digit special and
    SWAP 10 * SWAP 2 DO    \ I is 2 .. max-digit-1
      DUP I + I 2digit
    LOOP 2DROP
  ELSE
    SWAP 10 * SWAP 2 PICK ?DO  \ I is #digits .. max-digit-1
      DUP I + 2 PICK 1- SWAP I RECURSE  \ Recurse with #digits reduced by 1.
    LOOP 2DROP
  THEN ;

: descending-primes
  \ Print the descending primes.  Call digits with increasing #digits
  CR  9 1 DO   I 0 10 digits   LOOP ;
