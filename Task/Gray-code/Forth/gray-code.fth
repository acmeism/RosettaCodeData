: >gray ( n -- n' ) dup 2/ xor ;   \ n' = n xor (n logically right shifted 1 time)
                                               \ 2/ is Forth divide by 2, ie: shift right 1
: gray> ( n -- n )
  0  1 31 lshift  ( -- g b mask )
  begin
    >r                                        \ save a copy of mask on return stack
     2dup 2/ xor
     r@ and or
     r> 1 rshift
     dup 0=
  until
  drop nip ;                                  \ clean the parameter stack leaving result only

: test
  2 base !                                    \ set system number base to 2. ie: Binary
  32 0 do
    cr I  dup 5 .r ."  ==> "                  \ print numbers (binary) right justified 5 places
    >gray dup 5 .r ."  ==> "
    gray>     5 .r
  loop
  decimal ;                                   \ revert to BASE 10
