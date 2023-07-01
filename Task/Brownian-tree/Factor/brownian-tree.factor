USING: accessors images images.loader kernel literals math
math.vectors random sets ;
FROM: sets => in? ;
EXCLUDE: sequences => move ;
IN: rosetta-code.brownian-tree

CONSTANT: size 512
CONSTANT: num-particles 30000
CONSTANT: seed { 256 256 }
CONSTANT: spawns { { 10 10 } { 502 10 } { 10 502 } { 502 502 } }
CONSTANT: bg-color B{ 0 0 0 255 }
CONSTANT: fg-color B{ 255 255 255 255 }

: in-bounds? ( loc -- ? )
    dup { 0 0 } ${ size 1 - dup } vclamp = ;

: move ( loc -- loc' )
    dup 2 [ { 1 -1 } random ] replicate v+ dup in-bounds?
    [ nip ] [ drop ] if ;

: grow ( particles -- particles' )
    spawns random dup
    [ 2over swap in? ] [ drop dup move swap ] until nip
    swap [ adjoin ] keep ;

: brownian-data ( -- seq )
    HS{ $ seed } clone num-particles 1 - [ grow ] times { }
    set-like ;

: blank-bitmap ( -- bitmap )
    size sq [ bg-color ] replicate B{ } concat-as ;

: init-img ( -- img )
    <image>
    ${ size size }   >>dim
    BGRA             >>component-order
    ubyte-components >>component-type
    blank-bitmap     >>bitmap ;

: brownian-img ( -- img )
    init-img dup brownian-data
    [ swap [ fg-color swap first2 ] dip set-pixel-at ] with each
    ;

: save-brownian-tree-image ( -- )
    brownian-img "brownian.png" save-graphic-image ;

MAIN: save-brownian-tree-image
