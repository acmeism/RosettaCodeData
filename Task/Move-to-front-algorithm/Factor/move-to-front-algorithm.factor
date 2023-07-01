USING: formatting kernel locals make sequences ;

: to-front ( elt seq -- seq' ) over [ remove ] dip prefix ;

: encode ( symbols msg -- indices )
    [ [ swap 2dup index , to-front ] each ] { } make nip ;

: decode ( symbols indices -- msg )
    [ [ swap [ nth ] keep over , to-front ] each ] "" make nip ;

:: round-trip ( msg symbols -- )
    symbols msg encode :> encoded
    symbols encoded decode :> decoded
    msg decoded assert=
    msg encoded decoded "%s -> %u -> %s\n" printf ;

"broood" "bananaaa" "hiphophiphop"
[ "abcdefghijklmnopqrstuvwxyz" round-trip ] tri@
