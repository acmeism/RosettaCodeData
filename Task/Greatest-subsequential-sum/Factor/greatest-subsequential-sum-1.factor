USING: kernel locals math math.order sequences ;

:: max-with-index ( elt0 ind0 elt1 ind1 -- elt ind )
elt0 elt1 <  [ elt1 ind1 ] [ elt0 ind0 ] if ;
: last-of-max ( accseq -- ind ) -1 swap -1 [ max-with-index ] reduce-index nip ;

: max-subseq ( seq -- subseq )
dup 0 [ + 0 max ] accumulate swap suffix last-of-max head
dup 0 [ + ] accumulate swap suffix [ neg ] map last-of-max tail ;
