USING: combinators csv io kernel sequences strings ;
IN: rosetta-code.csv-to-html

CONSTANT: input

"Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!"

: escape-chars ( seq -- seq' )
    [
        {
            { CHAR: & [ "&amp;"  ] }
            { CHAR: ' [ "&apos;" ] }
            { CHAR: < [ "&lt;"   ] }
            { CHAR: > [ "&gt;"   ] }
            [ 1string ]
        } case
    ] { } map-as concat ;

: tag ( str tag -- <tag>str</tag> )
    [ "<" ">" surround ] [ "</" ">" surround ] bi surround ;

: csv>table ( seq -- str )
    [ [ "td" tag ] map concat "tr" tag "  " prepend ] map
    { "<table>" } prepend { "</table>" } append "\n" join ;

input escape-chars string>csv csv>table print
