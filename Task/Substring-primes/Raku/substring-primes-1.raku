my @p = (^10).grep: *.is-prime;

say gather while @p {
    .take for @p;

    @p = ( @p X~ <3 7> ).grep: { .is-prime and .substr(*-2,2).is-prime }
}
