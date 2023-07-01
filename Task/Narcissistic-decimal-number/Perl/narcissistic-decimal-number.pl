use v5.36;

sub is_narcissistic ($n) {
    my($k, $sum) = (length $n, 0);
    $sum += $_**$k for split '', $n;
    $n == $sum
}

my ($i,@N) = 0;
while (@N < 25) {
    $i++ while not is_narcissistic $i;
    push @N, $i++
}

say join ' ', @N;
