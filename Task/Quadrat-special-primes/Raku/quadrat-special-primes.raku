my @sqp = 2, -> $previous {
    my $next;
    for (1..∞).map: *² {
        $next = $previous + $_;
        last if $next.is-prime;
    }
    $next
} … *;

say "{+$_} matching numbers:\n", $_».fmt('%5d').batch(7).join: "\n" given
    @sqp[^(@sqp.first: * > 16000, :k)];
