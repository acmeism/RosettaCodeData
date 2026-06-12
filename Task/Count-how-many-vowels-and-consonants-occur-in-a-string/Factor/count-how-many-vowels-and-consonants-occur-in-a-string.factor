USING: ascii combinators io kernel math.statistics prettyprint
sequences ;

: letter-type ( char -- str )
    {
        { [ dup "aeiouAEIOU" member? ] [ drop "vowel" ] }
        { [ Letter? ] [ "consonant" ] }
        [ "other" ]
    } cond ;

"Forever Factor programming language"
"Now is the time for all good men to come to the aid of their country."
[ dup ... " -> " write [ letter-type ] histogram-by . nl ] bi@
