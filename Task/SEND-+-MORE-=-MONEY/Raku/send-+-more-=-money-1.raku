enum <D E M N O R S Y>;

sub find_solution ( ) {
    for ('0'..'9').combinations(8) -> @c {
        .return with @c.permutations.first: -> @p {
            @p[M] !== 0 and

            @p[  S,E,N,D].join
          + @p[  M,O,R,E].join
         == @p[M,O,N,E,Y].join
        }
    }
}

my @s = find_solution();
say "    {@s[  S,E,N,D].join}";
say " +  {@s[  M,O,R,E].join}";
say "== { @s[M,O,N,E,Y].join}";
