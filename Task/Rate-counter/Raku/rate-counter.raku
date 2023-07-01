sub runrate($N where $N > 0, &todo) {
    my $n = $N;

    my $start = now;
    todo() while --$n;
    my $end = now;

    say "Start time: ", DateTime.new($start).Str;
    say "End time: ", DateTime.new($end).Str;
    my $elapsed = $end - $start;

    say "Elapsed time: $elapsed seconds";
    say "Rate: { ($N / $elapsed).fmt('%.2f') } per second\n";
}

sub factorial($n) { (state @)[$n] //= $n < 2 ?? 1 !! $n * factorial($n-1) }

runrate 100_000, { state $n = 1; factorial($n++) }

runrate 100_000, { state $n = 1; factorial($n++) }
