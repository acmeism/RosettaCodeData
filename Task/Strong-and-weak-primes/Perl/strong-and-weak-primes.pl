use ntheory qw(primes vecfirst);

sub comma {
    (my $s = reverse shift) =~ s/(.{3})/$1,/g;
    $s =~ s/,(-?)$/$1/;
    $s = reverse $s;
}

sub below { my ($m, @a) = @_; vecfirst { $a[$_] > $m } 0..$#a }

my (@strong, @weak, @balanced);
my @primes = @{ primes(10_000_019) };

for my $k (1 .. $#primes - 1) {
    my $x = ($primes[$k - 1] + $primes[$k + 1]) / 2;
    if    ($x > $primes[$k]) { push @weak,     $primes[$k] }
    elsif ($x < $primes[$k]) { push @strong,   $primes[$k] }
    else                     { push @balanced, $primes[$k] }
}

for ([\@strong,   'strong',   36, 1e6, 1e7],
     [\@weak,     'weak',     37, 1e6, 1e7],
     [\@balanced, 'balanced', 28, 1e6, 1e7]) {
    my($pr, $type, $d, $c1, $c2) = @$_;
    print "\nFirst $d $type primes:\n", join ' ', map { comma $_ } @$pr[0..$d-1], "\n";
    print "Count of $type primes <=  @{[comma $c1]}:  " . comma below($c1,@$pr) . "\n";
    print "Count of $type primes <= @{[comma $c2]}: "   . comma scalar @$pr . "\n";
}
