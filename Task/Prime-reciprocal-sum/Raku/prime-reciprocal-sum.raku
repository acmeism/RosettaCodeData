sub abbr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '..' ~ .substr(*-20) ~ " ({.chars} digits)" }

sub next-prime {
    state $sum = 0;
    my $next = ((1 / (1 - $sum)).ceiling+1..*).hyper(:2batch).grep(&is-prime)[0];
    $sum += FatRat.new(1,$next);
    $next;
}

printf "%2d: %s\n", $_, abbr next-prime for 1..15;
