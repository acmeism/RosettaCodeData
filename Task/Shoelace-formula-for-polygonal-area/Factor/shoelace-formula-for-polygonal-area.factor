USING: circular kernel math prettyprint sequences ;
IN: rosetta-code.shoelace

CONSTANT: input { { 3 4 } { 5 11 } { 12 8 } { 9 5 } { 5 6 } }

: align-pairs ( pairs-seq -- seq1 seq2 )
    <circular> dup clone [ 1 ] dip
    [ change-circular-start ] keep ;

: shoelace-sum ( seq1 seq2 -- n )
    [ [ first ] [ second ] bi* * ] 2map sum ;

: shoelace-area ( pairs-seq -- area )
    [ align-pairs ] [ align-pairs swap ] bi
    [ shoelace-sum ] 2bi@ - abs 2 / ;

input shoelace-area .
