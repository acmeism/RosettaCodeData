USING: spelling ; ! ALPHABET

ALPHABET print
0x61 0x7A [a,b] >string print
: russian-alphabet-without-io ( -- str ) 0x0430 0x0450 [a,b) >string ;
: russian-alphabet ( -- str ) 0x0451 6 russian-alphabet-without-io insert-nth ;
russian-alphabet print
