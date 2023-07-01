USING: formatting kernel math regexp sequences splitting
splitting.extras unicode ;

! ignore leading/trailing whitespace
: preserve ( str quot -- newstr )
    [ [ blank? ] split-head [ blank? ] split-tail swap ] dip
    call glue ; inline

: >snake ( str -- newstr )
    [
        R/ (\p{lower}\p{upper}|\d\p{alpha}|\p{alpha}\d)/
        [ 1 short cut >lower "_" glue ] re-replace-with
        R/ [\s-]/ "_" re-replace
    ] preserve ;

: capitalize ( str -- newstr ) 1 short cut swap >upper prepend ;

: >camel ( str -- newstr )
    [
        "\s_-" split harvest 1 short cut
        [ capitalize ] map append "" join
    ] preserve ;

: test ( str -- )
    dup >snake over dup >camel
    "%u >snake %u\n%u >camel %u\n" printf ;

{
    "snakeCase" "snake_case" "variable_10_case" "variable10Case"
    "ɛrgo rE tHis" "hurry-up-joe!"
    "c://my-docs/happy_Flag-Day/12.doc" "  spaces  "
    "   internal space   "
} [ test ] each
