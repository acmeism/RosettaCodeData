USING: backtrack continuations kernel prettyprint sequences ;
IN: amb

CONSTANT: words {
    { "the" "that" "a" }
    { "frog" "elephant" "thing" }
    { "walked" "treaded" "grows" }
    { "slowly" "quickly"  }
}

: letters-match? ( str1 str2 -- ? ) [ last ] [ first ] bi* = ;

: sentence-match? ( seq -- ? ) dup rest [ letters-match? ] 2all? ;

: select ( seq -- seq' ) [ amb-lazy ] map ;

: search ( -- )
    words select dup sentence-match? [ " " join ] [ fail ] if . ;

MAIN: search
