USING: formatting io kernel sequences ;
IN: rosetta-code.fasta

: process-fasta-line ( str -- )
    dup ">" head? [ rest "\n%s: " printf ] [ write ] if ;

: main ( -- )
    readln rest "%s: " printf [ process-fasta-line ] each-line ;

MAIN: main
