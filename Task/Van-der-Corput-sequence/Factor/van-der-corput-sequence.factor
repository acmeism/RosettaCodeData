USING: formatting fry io kernel math math.functions math.parser
math.ranges sequences ;
IN: rosetta-code.van-der-corput

: vdc ( n base -- x )
    [ >base string>digits <reversed> ]
    [ nip '[ 1 + neg _ swap ^ * ] ] 2bi map-index sum ;

: vdc-demo ( -- )
    2 5 [a,b] [
        dup "Base %d: " printf 10 <iota>
        [ swap vdc "%-5u " printf ] with each nl
    ] each ;

MAIN: vdc-demo
