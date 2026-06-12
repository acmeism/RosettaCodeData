# ABC correlation - print words that contain equal numbers of as, bs and cs
{
    for( w = 1; w <= NF; w ++ )
    {
        word = $( w );
        as = bs = cs = word;
        gsub( /[^Aa]/, "", as );
        gsub( /[^Bb]/, "", bs );
        gsub( /[^Cc]/, "", cs );
        if( length( as ) == length( bs ) && length( as ) == length( cs ) )
        {
            printf( "%s\n", word );
        }
    }
}
