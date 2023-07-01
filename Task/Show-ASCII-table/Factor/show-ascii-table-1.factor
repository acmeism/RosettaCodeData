USING: combinators formatting io kernel math math.ranges
pair-rocket sequences ;
IN: rosetta-code.ascii-table

: row-values ( n -- seq ) [ 32 + ] [ 112 + ] bi 16 <range> ;

: ascii>output ( n -- str )
    { 32 => [ "Spc" ] 127 => [ "Del" ] [ "" 1sequence ] } case ;

: print-row ( n -- )
    row-values [ dup ascii>output "%3d : %-3s   " printf ] each nl ;

: print-ascii-table ( -- ) 16 <iota> [ print-row ] each ;

MAIN: print-ascii-table
