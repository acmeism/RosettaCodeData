: addRange( s res -- )
| i n |
    s asInteger dup ifNotNull: [ res add return ] drop
    s indexOfFrom('-', 2) ->i
    s left( i 1- ) asInteger  s right( s size i - ) asInteger
    for: n [ n res add ]
;

: rangeExpand ( s -- [ n ] )
    ArrayBuffer new  s wordsWith( ',' ) apply( #[ over addRange ] ) ;
