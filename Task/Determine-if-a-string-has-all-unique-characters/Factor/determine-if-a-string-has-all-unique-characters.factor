USING: formatting fry generalizations io kernel math.parser
sequences sets ;

: repeated ( elt seq -- )
    [ dup >hex over ] dip indices first2
    "  '%c' (0x%s) at indices %d and %d.\n" printf ;

: uniqueness-report ( str -- )
    dup dup length "%u — length %d — contains " printf
    [ duplicates ] keep over empty?
    [ 2drop "all unique characters." print ]
    [ "repeated characters:" print '[ _ repeated ] each ] if ;

""
"."
"abcABC"
"XYZ ZYX"
"1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"
[ uniqueness-report nl ] 5 napply
