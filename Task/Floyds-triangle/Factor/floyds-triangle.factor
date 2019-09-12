USING: io kernel math math.functions math.ranges prettyprint
sequences ;
IN: rosetta-code.floyds-triangle

: floyd. ( n -- )
    [ dup 1 - * 2 / 1 + dup 1 ] [ [1,b] ] bi
    [
        [
            2dup [ log10 1 + >integer ] bi@ -
            [ " " write ] times dup pprint bl [ 1 + ] bi@
        ] times nl [ drop dup ] dip
    ] each nl 3drop ;

5 14 [ floyd. ] bi@
