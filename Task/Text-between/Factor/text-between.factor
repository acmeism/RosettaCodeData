USING: combinators formatting kernel locals math
prettyprint.config sequences ;
IN: rosetta-code.text-between

:: start ( sdelim text -- n )
    {
        { [ sdelim "start" = ] [ 0 ] }
        { [ sdelim text subseq-start ] [ sdelim text subseq-start sdelim length + ] }
        [ text length ]
    } cond ;

:: end ( edelim text i -- n )
    {
        { [ edelim "end" = ] [ text length ] }
        { [ edelim text i subseq-start-from ] [ edelim text i subseq-start-from ] }
        [ text length ]
    } cond ;

:: text-between ( text sdelim edelim -- seq )
    sdelim text start :> start-index
    edelim text start-index end :> end-index
    start-index end-index text subseq ;

: text-between-demo ( -- )
    {
        { "Hello Rosetta Code world" "Hello " " world" }
        { "Hello Rosetta Code world" "start" " world" }
        { "Hello Rosetta Code world" "Hello " "end" }
        { "</div><div style=\"chinese\">你好嗎</div>" "<div style=\"chinese\">" "</div>" }
        { "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">" "<text>" "<table>" }
        { "<table style=\"myTable\"><tr><td>hello world</td></tr></table>" "<table>" "</table>" }
        { "The quick brown fox jumps over the lazy other fox" "quick " " fox" }
        { "One fish two fish red fish blue fish" "fish " " red" }
        { "FooBarBazFooBuxQuux" "Foo" "Foo" }
    }
    [
        first3 3dup text-between [
            "Text: %u\nStart delimiter: %u\nEnd delimiter: %u\nOutput: %u\n\n"
            printf
        ] without-limits  ! prevent the prettyprinter from culling output
    ] each ;

MAIN: text-between-demo
