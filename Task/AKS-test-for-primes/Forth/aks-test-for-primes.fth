: coeffs ( u -- nu ... n0 ) \ coefficients of (x-1)^u
   1 swap 1+ dup 1 ?do over over i - i */ negate swap loop drop ;

: prime? ( u -- f )
   dup 2 < if drop false exit then
   dup >r coeffs 1+
   \ if not prime, this loop consumes at most half the coefficients, otherwise all
   begin dup 1 <> while
      r@ mod 0= while
   repeat then rdrop
   dup 1 = >r
   begin 1 = until
   r> ;

: .monom ( u1 u2 -- )
   dup 0> if [char] + emit then 0 .r ?dup if ." x^" . else space then ;
: .poly ( u -- )
   dup >r coeffs 0 r> 1+ 0 ?do
      tuck swap .monom 1+
   loop ;

: main
   11 0 ?do i . ." : " i .poly cr loop cr
   50 1 ?do i prime? if i . then loop
   cr ;
