USING: combinators.short-circuit.smart formatting grouping io
kernel make math prettyprint sequences sets ;

: coprime? ( m n -- ? ) simple-gcd 1 = ;

: coprime-both? ( m n o -- ? ) '[ _ coprime? ] both? ;

: triplet? ( hs m n o -- ? )
    { [ coprime-both? nip ] [ 2nip swap in? not ] } && ;

: next ( hs m n -- hs' m' n' )
    0 [ 4dup triplet? ] [ 1 + ] until
    nipd pick [ adjoin ] keepd ;

: (triplets-upto) ( n -- )
    [ HS{ 1 2 } clone 1 , 1 2 ] dip
    '[ 2dup [ _ < ] both? ] [ dup , next ] while 3drop ;

: triplets-upto ( n -- seq ) [ (triplets-upto) ] { } make ;

"Coprime triplets under 50:" print
50 triplets-upto
[ 9 group simple-table. nl ]
[ length "Found %d terms.\n" printf ] bi
