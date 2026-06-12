\ add two 15 digit bcd numbers
\
: bcd+ ( n1 n2 -- n3 )
    0x0666666666666666 +    \ offset the digits in n2
    2dup xor                \ add, discounting carry
    -rot + swap             \ add with carry (only carries have correct digit)
    over xor                \ bitmask of where carries occurred.
    invert 0x1111111111111110 and   \ invert then change digit to 6
    dup 2 rshift swap 3 rshift or   \ in each non-carry position
    - 0x0FFFFFFFFFFFFFFF and ;      \ subtract bitmask from result, discard MSD

: bcdneg ( n -- n )    \ reduction of 9999...9999 swap - 1 bcd+
    negate 0x0FFFFFFFFFFFFFFF and dup 1-
    1 xor over xor invert 0x1111111111111110 and
    dup 2 rshift swap 3 rshift or - ;

: bcd-  bcdneg bcd+ ;
