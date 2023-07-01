: mergestep ( accum seq1 seq2 -- accum seq1 seq2 )
2dup [ first ] bi@ <
[ [ [ first ] [ rest-slice ] bi [ suffix ] dip ] dip ]
[ [ first ] [ rest-slice ] bi [ swap [ suffix ] dip ] dip ]
if ;

: merge ( seq1 seq2 -- merged )
[ { } ] 2dip
[ 2dup [ length 0 > ] bi@ and ]
[ mergestep ] while
append append ;

: mergesort ( seq -- sorted )
dup length 1 >
[ dup length 2 / floor [ head ] [ tail ] 2bi [ mergesort ] bi@ merge ]
[ ] if ;
