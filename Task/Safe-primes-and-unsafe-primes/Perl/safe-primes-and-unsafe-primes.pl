use ntheory qw(forprimes is_prime);

my $upto = 1e7;
my %class = ( safe => [], unsafe => [2] );

forprimes {
    push @{$class{ is_prime(($_-1)>>1) ? 'safe' : 'unsafe' }}, $_;
} 3, $upto;

for (['safe', 35], ['unsafe', 40]) {
    my($type, $quantity) = @$_;
    print  "The first $quantity $type primes are:\n";
    print join(" ", map { comma($class{$type}->[$_-1]) } 1..$quantity), "\n";
    for my $q ($upto/10, $upto) {
        my $n = scalar(grep { $_ <= $q } @{$class{$type}});
        printf "The number of $type primes up to %s: %s\n", comma($q), comma($n);
    }
}

sub comma {
    (my $s = reverse shift) =~ s/(.{3})/$1,/g;
    $s =~ s/,(-?)$/$1/;
    $s = reverse $s;
}
