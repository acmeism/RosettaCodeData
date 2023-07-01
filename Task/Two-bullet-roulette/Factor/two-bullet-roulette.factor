USING: accessors assocs circular formatting fry kernel literals
math random sequences ;
IN: rosetta-code.roulette

CONSTANT: cyl $[ { f f f f f f } <circular> ]

: cylinder ( -- seq ) cyl [ drop f ] map! ;

: load ( seq -- seq' )
    0 over nth [ dup rotate-circular ] when
    t 0 rot [ set-nth ] [ rotate-circular ] [ ] tri ;

: spin ( seq -- seq' ) [ 6 random 1 + + ] change-start ;

: fire ( seq -- ? seq' )
    [ 0 swap nth ] [ rotate-circular ] [ ] tri ;

: LSLSFSF ( -- ? ) cylinder load spin load spin fire spin fire drop or ;
: LSLSFF  ( -- ? ) cylinder load spin load spin fire fire drop or ;
: LLSFSF  ( -- ? ) cylinder load load spin fire spin fire drop or ;
: LLSFF   ( -- ? ) cylinder load load spin fire fire drop or ;

: percent ( ... n quot: ( ... -- ... ? ) -- ... x )
    0 -rot '[ _ call( -- ? ) 1 0 ? + ] [ times ] keepd /f 100 * ; inline

: run-test ( description quot -- )
    100,000 swap percent
    "Method <%s> produces %.3f%% deaths.\n" printf ;

: main ( -- )
    {
        { "load, spin, load, spin, fire, spin, fire" [ LSLSFSF ] }
        { "load, spin, load, spin, fire, fire" [ LSLSFF ] }
        { "load, load, spin, fire, spin, fire" [ LLSFSF ] }
        { "load, load, spin, fire, fire" [ LLSFF ] }
    } [ run-test ] assoc-each ;

MAIN: main
