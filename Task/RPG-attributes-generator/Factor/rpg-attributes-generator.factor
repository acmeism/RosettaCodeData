USING: combinators.short-circuit dice formatting io kernel math
math.statistics qw sequences ;
IN: rosetta-code.rpg-attributes-generator

CONSTANT: stat-names qw{ Str Dex Con Int Wis Cha }

: attribute ( -- n )
    4 [ ROLL: 1d6 ] replicate 3 <iota> kth-largests sum ;

: stats ( -- seq ) 6 [ attribute ] replicate ;

: valid-stats? ( seq -- ? )
    { [ [ 15 >= ] count 2 >= ] [ sum 75 >= ] } 1&& ;

: generate-valid-stats ( -- seq )
    stats [ dup valid-stats? ] [ drop stats ] until ;

: stats-info ( seq -- )
    [ sum ] [ [ 15 >= ] count ] bi
    "Total: %d\n# of attributes >= 15: %d\n" printf ;

: main ( -- )
    generate-valid-stats dup stat-names swap
    [ "%s: %d\n" printf ] 2each nl stats-info ;

MAIN: main
