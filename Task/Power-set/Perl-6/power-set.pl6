sub powerset ( *@list ) {
    reduce( -> @L, $n { [ @L, @L.map({[ $_.list, $n ]}) ] }, [[]], @list );
}
