my ($trials, $t-total, $s-total) = 10000;

say 'Seconds  steps behind  steps ahead';

race for ^$trials {
    my $stairs   = 100;
    my $location = 0;
    my $seconds  = 0;

    loop {
        ++$seconds;
        ++$location;
        last if $location > $stairs;
        for (1..$stairs).roll(5) {
            ++$location if $_ <= $location;
            ++$stairs;
        }
        say "  $seconds        $location         {$stairs-$location}" if !$_ && (599 < $seconds < 610);
    }

    $t-total += $seconds;
    $s-total += $stairs;
}

say "Average seconds: {$t-total/$trials},  Average steps: {$s-total/$trials}";
