constant MAX_N  = 20;
constant TRIALS = 100;

for 1 .. MAX_N -> $N {
    my $empiric = TRIALS R/ [+] find-loop(random-mapping($N)).elems xx TRIALS;
    my $theoric = [+]
        map -> $k { $N ** ($k + 1) R/ [*] flat $k**2, $N - $k + 1 .. $N }, 1 .. $N;

    FIRST say " N    empiric      theoric      (error)";
    FIRST say "===  =========  ============  =========";

    printf "%3d  %9.4f  %12.4f    (%4.2f%%)\n",
            $N,  $empiric,
                        $theoric, 100 * abs($theoric - $empiric) / $theoric;
}

sub random-mapping { hash .list Z=> .roll given ^$^size }
sub find-loop { 0, | %^mapping{*} ...^ { (%){$_}++ } }
