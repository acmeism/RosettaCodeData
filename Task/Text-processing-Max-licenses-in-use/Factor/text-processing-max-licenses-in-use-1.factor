USING: kernel sequences splitting math accessors io.encodings.ascii
io.files math.parser io ;
IN: maxlicenses

TUPLE: maxlicense max-count current-count times ;

<PRIVATE

: <maxlicense> ( -- max ) -1 0 V{ } clone \ maxlicense boa ; inline

: out? ( line -- ? ) [ "OUT" ] dip subseq? ; inline

: line-time ( line -- time ) " " split harvest fourth ; inline

: update-max-count ( max -- max' )
    dup [ current-count>> ] [ max-count>> ] bi >
    [ dup current-count>> >>max-count V{ } clone >>times ] when ;

: (inc-current-count) ( max ? -- max' )
    [ [ 1 + ] change-current-count ]
    [ [ 1 - ] change-current-count ]
    if
    update-max-count ; inline

: inc-current-count ( max ? time -- max' time )
    [ (inc-current-count) ] dip ;

: current-max-equal? ( max -- max ? )
    dup [ current-count>> ] [ max-count>> ] bi = ;

: update-time ( max time -- max' )
    [ current-max-equal? ] dip
    swap
    [ [ suffix ] curry change-times ] [ drop ] if ;

: split-line ( line -- ? time ) [ out? ] [ line-time ] bi ;

: process ( max line -- max ) split-line inc-current-count update-time ;

PRIVATE>

: find-max-licenses ( -- max )
    "resource:work/mlijobs.txt" ascii file-lines
    <maxlicense> [ process ] reduce ;

: print-max-licenses ( max -- )
    [ times>> ] [ max-count>> ] bi
    "Maximum simultaneous license use is " write
    number>string write
    " at the following times: " print
    [ print ] each ;
