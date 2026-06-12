USING: assocs formatting grouping kernel math math.combinatorics
prettyprint sequences sequences.repeating sets ;

: jaccard ( seq1 seq2 -- x )
    2dup [ empty? ] both? [ 2drop 1 ]
    [ [ intersect ] [ union ] 2bi [ length ] bi@ / ] if ;

{ { } { 1 2 3 4 5 } { 1 3 5 7 9 } { 2 4 6 8 10 } { 2 3 5 7 } { 8 } }
[ 2 <combinations> ] [ 2 repeat 2 group append ] bi
[ 2dup jaccard "%u %u -> %u\n" printf ] assoc-each
