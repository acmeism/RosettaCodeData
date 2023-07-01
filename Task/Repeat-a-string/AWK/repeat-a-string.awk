function repeat( str, n,    rep, i )
{
    for( ; i<n; i++ )
        rep = rep str
    return rep
}

BEGIN {
    print repeat( "ha", 5 )
}
