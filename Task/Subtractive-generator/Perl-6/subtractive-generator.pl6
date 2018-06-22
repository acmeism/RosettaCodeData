sub bentley-clever($seed) {
    constant $mod = 1_000_000_000;
    my @seeds = ($seed % $mod, 1, (* - *) % $mod ... *)[^55];
    my @state = @seeds[ 34, (* + 34 ) % 55 ... 0 ];

    sub subrand() {
        push @state, (my $x = (@state.shift - @state[*-24]) % $mod);
        $x;
    }

    subrand for 55 .. 219;

    &subrand ... *;
}

my @sr = bentley-clever(292929);
.say for @sr[^10];
