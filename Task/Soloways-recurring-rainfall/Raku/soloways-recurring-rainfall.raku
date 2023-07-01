# Write a program that will read in integers and
# output their average. Stop reading when the
# value 99999 is input.


my ($periods, $accumulation, $rainfall) = 0, 0;

loop {
    loop {
        $rainfall = prompt 'Integer units of rainfall in this time period? (999999 to finalize and exit)>: ';
        last if $rainfall.chars and $rainfall.Numeric !~~ Failure and $rainfall.narrow ~~ Int and $rainfall ≥ 0;
        say 'Invalid input, try again.';
    }
    last if $rainfall == 999999;
    ++$periods;
    $accumulation += $rainfall;
    say-it;
}

say-it;

sub say-it { printf "Average rainfall %.2f units over %d time periods.\n", ($accumulation / $periods) || 0, $periods }
