sub MAIN ($beats-per-minute = 72, $beats-per-bar = 4) {
    my $duration = 60 / $beats-per-minute;
    my $base-time = now + $duration;
    my $i;

    for $base-time, $base-time + $duration ... * -> $next-time {
        if $i++ %% $beats-per-bar {
            print "\nTICK";
        }
        else {
            print  " tick";
        }
        sleep $next-time - now;
    }
}
