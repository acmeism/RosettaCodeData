use List::Util qw(none sum);

sub gcd { my ($u,$v) = @_; $v ? gcd($v, $u%$v) : abs($u) }
sub shares_divisors_with { gcd( $_[0], $_[1]) > 1 }

sub EKG {
    my($n,$limit) = @_;
    my @ekg = (1, $n);
    while (@ekg < $limit) {
        for my $i (2..1e18) {
            next unless none { $_ == $i } @ekg and shares_divisors_with($ekg[-1], $i);
            push(@ekg, $i) and last;
        }
    }
    @ekg;
}

sub converge_at {
    my($n1,$n2) = @_;
    my $max = 100;
    my @ekg1 = EKG($n1,$max);
    my @ekg2 = EKG($n2,$max);
    do { return $_+1 if $ekg1[$_] == $ekg2[$_] && sum(@ekg1[0..$_]) == sum(@ekg2[0..$_])} for 2..$max;
    return "(no convergence in $max terms)";
}

print "EKG($_): " . join(' ', EKG($_,10)) . "\n" for 2, 5, 7, 9, 10;
print "EKGs of 5 & 7 converge at term " . converge_at(5, 7) . "\n"
