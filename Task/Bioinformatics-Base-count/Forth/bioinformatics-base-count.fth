( Gforth 0.7.3 )

: dnacode s" CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATATTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTATCGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTGTCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGACGACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT" ;

variable #A \ Gforth initialises variables to 0
variable #C
variable #G
variable #T
variable #ch
50 constant pplength

: basecount ( adr u -- )
    ." Sequence:"
    swap dup rot + swap ?do  \ count while pretty-printing
        #ch @ pplength mod 0= if cr #ch @ 10 .r 2 spaces then
        i c@ dup emit
        dup 'A = if drop #A @ 1+ #A ! else
        dup 'C = if drop #C @ 1+ #C ! else
        dup 'G = if drop #G @ 1+ #G ! else
        dup 'T = if drop #T @ 1+ #T ! else drop then then then then
        #ch @ 1+ #ch !
    loop
    cr cr ." Base counts:"
    cr 4 spaces 'A emit ': emit #A @ 5 .r
    cr 4 spaces 'C emit ': emit #C @ 5 .r
    cr 4 spaces 'G emit ': emit #G @ 5 .r
    cr 4 spaces 'T emit ': emit #T @ 5 .r
    cr ."  ----------"
    cr ."   Sum:"  #ch @ 5 .r
    cr ."  ==========" cr cr
;

( demo run: )

dnacode basecount
