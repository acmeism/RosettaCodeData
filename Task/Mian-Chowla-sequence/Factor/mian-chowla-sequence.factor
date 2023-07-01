USING: fry hash-sets io kernel math prettyprint sequences sets ;

: next ( seq sums speculative -- seq' sums' speculative' )
    dup reach [ + ] with map over dup + suffix! >hash-set pick
    over intersect null?
    [ swapd union [ [ suffix! ] keep ] dip swap ] [ drop ] if
    1 + ;

: mian-chowla ( n -- seq )
    [ V{ 1 } HS{ 2 } [ clone ] bi@ 2 ] dip
    '[ pick length _ < ] [ next ] while 2drop ;

100 mian-chowla
[ 30 head "First 30 terms of the Mian-Chowla sequence:" ]
[ 10 tail* "Terms 91-100 of the Mian-Chowla sequence:" ] bi
[ print [ pprint bl ] each nl nl ] 2bi@
