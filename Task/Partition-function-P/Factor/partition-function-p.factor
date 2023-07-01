USING: kernel lists lists.lazy math sequences sequences.extras ;

! Compute the nth pentagonal number.
: penta ( n -- m ) [ sq 3 * ] [ - 2/ ] bi ;

! An infinite lazy list of indices to add and subtract in the
! sequence of partitions to find the next P.
: seq ( -- list )
    1 lfrom [ penta 1 - ] <lazy-map> 1 lfrom [ neg penta 1 - ]
    <lazy-map> lmerge ;

! Reduce a sequence by adding two, subtracting two, adding two,
! etc...
: ++-- ( seq -- n ) 0 [ 2/ odd? [ - ] [ + ] if ] reduce-index ;

! Find the next member of the partitions sequence.
: step ( seq pseq -- seq 'pseq )
    dup length [ < ] curry pick swap take-while over <reversed>
    nths ++-- suffix! ;

: partitions ( m -- n )
    [ seq swap [ <= ] curry lwhile list>array ]
    [ V{ 1 } clone swap [ step ] times last nip ] bi ;
