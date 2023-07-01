USING: html.streams literals prettyprint random xml.writer ;

: rnd ( -- n ) 10,000 random ;

{
     { "" "X" "Y" "Z" }
    ${ 1  rnd rnd rnd }
    ${ 2  rnd rnd rnd }
    ${ 3  rnd rnd rnd }
}
[ simple-table. ] with-html-writer pprint-xml
