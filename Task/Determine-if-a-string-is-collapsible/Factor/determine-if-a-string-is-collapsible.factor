USING: formatting io kernel sbufs sequences strings ;
IN: rosetta-code.string-collapse

: (collapse) ( str -- str )
    unclip-slice 1string >sbuf
    [ over last over = [ drop ] [ suffix! ] if ] reduce >string ;

: collapse ( str -- str ) [ "" ] [ (collapse) ] if-empty ;

: .str ( str -- ) dup length "«««%s»»» (length %d)\n" printf ;

: show-collapse ( str -- )
    [ "Before collapse: " write .str ]
    [ "After  collapse: " write collapse .str ] bi nl ;

: collapse-demo ( -- )
    {
        ""
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
        "..1111111111111111111111111111111111111111111111111111111111111117777888"
        "I never give 'em hell, I just tell the truth, and they think it's hell. "
        "                                                   ---  Harry S Truman  "
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!"
        "headmistressship"
        "aardvark"
        "😍😀🙌💃😍😍😍🙌"
    } [ show-collapse ] each ;

MAIN: collapse-demo
