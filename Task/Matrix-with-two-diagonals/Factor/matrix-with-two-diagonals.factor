USING: io kernel math math.matrices prettyprint ;

: <x-matrix> ( n -- matrix )
    dup dup 1 - '[ 2dup = -rot + _ = or 1 0 ? ] <matrix-by-indices> ;

6 <x-matrix> simple-table. nl
7 <x-matrix> simple-table.
