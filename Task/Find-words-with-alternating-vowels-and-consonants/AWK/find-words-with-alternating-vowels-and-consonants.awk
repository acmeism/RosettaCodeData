( length( $1 ) >= 10 ) \
{
    # have an appropriate length word
    word          = $1;
    haveVowel     = word ~ /^[aeiou]/;
    isAlternating = 1;
    for( wPos = 2; isAlternating && wPos <= length( word ); wPos ++ )
    {
        hadVowel  = haveVowel;
        haveVowel = substr( word, wPos, 1 ) ~ /^[aeiou]/;
        isAlternating = ( hadVowel && ! haveVowel ) || ( ! hadVowel && haveVowel );
    } # for wPos
    if( isAlternating )
    {
        printf( " %16s%s", word, ( alternatingCount % 6 == 5 ) ? "\n" : "" );
        alternatingCount += 1;
    } # if isAlternating
}

END \
{
    printf( "\n%d words with alternating vowels and consonants found\n", alternatingCount );
} # END
