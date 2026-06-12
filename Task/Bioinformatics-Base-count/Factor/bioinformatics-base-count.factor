USING: assocs formatting grouping io kernel literals math
math.statistics prettyprint qw sequences sorting ;

CONSTANT: dna
$[
    qw{
        CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG
        CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG
        AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT
        GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT
        CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG
        TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA
        TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT
        CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG
        TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC
        GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT
    } concat
]

: .dna ( seq n -- )
    "SEQUENCE:" print [ group ] keep
    [ * swap "  %3d: %s\n" printf ] curry each-index ;

: show-counts ( seq -- )
    "BASE COUNTS:" print histogram >alist [ first ] sort-with
    [ [ "    %c: %3d\n" printf ] assoc-each ]
    [ "TOTAL: " write [ second ] [ + ] map-reduce . ] bi ;

dna [ 50 .dna nl ] [ show-counts ] bi
