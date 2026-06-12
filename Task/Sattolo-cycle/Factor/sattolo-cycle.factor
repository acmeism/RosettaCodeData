USING: arrays io kernel literals math math.ranges prettyprint
random sequences ;
IN: rosetta-code.sattolo-cycle

: (sattolo) ( seq -- seq' )
    dup dup length 1 - 1 [a,b]
    [ dup iota random rot exchange ] with each ;

: sattolo ( seq -- seq/seq' )
    dup length 1 > [ (sattolo) ] when ;

{
    { }
    { 10 }
    { 10 20 }
    { 10 20 30 }
    $[ 11 22 [a,b] >array ]
}
[
    [ "original: " write .         ]
    [ "cycled:   " write sattolo . ] bi nl
] each
