sub non_continuous_subsequences ( *@list ) {
    powerset(@list).grep: { 1 != all( .[ 0 ^.. .end] Z- .[0 ..^ .end] ) }
}

sub powerset ( *@list ) {
    reduce( -> @L, $n { [ @L, @L.map: {[ .list, $n ]} ] }, [[]], @list );
}

say ~ non_continuous_subsequences( 1..3 )».perl;
say ~ non_continuous_subsequences( 1..4 )».perl;
say ~ non_continuous_subsequences(   ^4 ).map: {[<a b c d>[.list]].perl};
