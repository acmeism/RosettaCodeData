# First 20

my @wagstaff = (^∞).grep: { .is-prime && ((1 + 1 +< $_)/3).is-prime };

say ++$ ~ ": $_ - {(1 + 1 +< $_)/3}" for @wagstaff[^20];

say .fmt("\nTotal elapsed seconds: (%.2f)\n") given (my $elapsed = now) - INIT now;

# However many I have patience for

my atomicint $count = 20;

hyper for @wagstaff[20] .. * {
    next unless .is-prime;
    say ++⚛$count ~ ": $_ ({sprintf "%.2f", now - $elapsed})" and $elapsed = now if is-prime (1 + 1 +< $_)/3;
}
