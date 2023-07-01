use ntheory qw/divisor_sum/;
sub is_perfect { my $n = shift;  divisor_sum($n) == 2*$n; }
