sub non_continuous_subsequences ( *@list ) {
    @list.combinations.grep: { 1 != all( .[ 0 ^.. .end] Z- .[0 ..^ .end] ) }
}

say non_continuous_subsequences( 1..3 )».gist;
say non_continuous_subsequences( 1..4 )».gist;
say non_continuous_subsequences(   ^4 ).map: {[<a b c d>[.list]].gist};
