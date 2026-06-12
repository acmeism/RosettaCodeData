USING: continuations formatting fry kernel sequences strings ;
IN: rosetta-code.lcp

! Find the longest common prefix of two strings.
: binary-lcp ( str1 str2 -- str3 )
    [ SBUF" " clone ] 2dip
    '[ _ _ [ over = [ suffix! ] [ drop return ] if ] 2each ]
    with-return >string ;

! Reduce a sequence of strings using binary-lcp.
: lcp ( seq -- str )
    [ "" ] [ dup first [ binary-lcp ] reduce ] if-empty ;

: lcp-demo ( -- )
    {
        { "interspecies" "interstellar" "interstate" }
        { "throne" "throne" }
        { "throne" "dungeon" }
        { "throne" "" "throne" }
        { "cheese" }
        { "" }
        { }
        { "prefix" "suffix" }
        { "foo" "foobar" }
    } [ dup lcp "%u lcp = %u\n" printf ] each ;

MAIN: lcp-demo
