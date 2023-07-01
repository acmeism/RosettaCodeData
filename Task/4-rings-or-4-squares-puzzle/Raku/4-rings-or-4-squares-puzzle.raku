sub four-squares ( @list, :$unique=1, :$show=1 ) {

    my @solutions;

    for $unique.&combos -> @c {
        @solutions.push: @c if [==]
          @c[0] + @c[1],
          @c[1] + @c[2] + @c[3],
          @c[3] + @c[4] + @c[5],
          @c[5] + @c[6];
    }

    say +@solutions, ($unique ?? ' ' !! ' non-'), "unique solutions found using {join(', ', @list)}.\n";

    my $f = "%{@list.max.chars}s";

    say join "\n", (('a'..'g').fmt: $f), @solutions».fmt($f), "\n" if $show;

    multi combos ( $ where so * ) { @list.combinations(7).map: |*.permutations }

    multi combos ( $ where not * ) { [X] @list xx 7 }
}

# TASK
four-squares( [1..7] );
four-squares( [3..9] );
four-squares( [8, 9, 11, 12, 17, 18, 20, 21] );
four-squares( [0..9], :unique(0), :show(0) );
