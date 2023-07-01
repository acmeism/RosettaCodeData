use ntheory qw/prime_iterator is_prime/;

sub tuple_tail {
    my($n,$cnt,@array) = @_;
    $n = @array if $n > @array;
    my @tail;
    for (1..$n) {
        my $p = $array[-$n+$_-1];
        push @tail, "(" . join(" ", map { $p+6*$_ } 0..$cnt-1) . ")";
    }
    return @tail;
}

sub comma {
    (my $s = reverse shift) =~ s/(.{3})/$1,/g;
    ($s = reverse $s) =~ s/^,//;
    return $s;
}

sub sexy_string { my $p = shift; is_prime($p+6) || is_prime($p-6) ? 'sexy' : 'unsexy' }

my $max = 1_000_035;
my $cmax = comma $max;

my $iter = prime_iterator;
my $p = $iter->();
my %primes;
push @{$primes{sexy_string($p)}}, $p;
while ( ($p = $iter->()) < $max) {
    push @{$primes{sexy_string($p)}}, $p;
    $p+ 6 < $max && is_prime($p+ 6) ? push @{$primes{'pair'}},       $p : next;
    $p+12 < $max && is_prime($p+12) ? push @{$primes{'triplet'}},    $p : next;
    $p+18 < $max && is_prime($p+18) ? push @{$primes{'quadruplet'}}, $p : next;
    $p+24 < $max && is_prime($p+24) ? push @{$primes{'quintuplet'}}, $p : next;
}

print "Total primes less than $cmax: " . comma(@{$primes{'sexy'}} + @{$primes{'unsexy'}}) . "\n\n";

for (['pair', 2], ['triplet', 3], ['quadruplet', 4], ['quintuplet', 5]) {
    my($sexy,$cnt) = @$_;
    print "Number of sexy prime ${sexy}s less than $cmax: " . comma(scalar @{$primes{$sexy}}) . "\n";
    print "   Last 5 sexy prime ${sexy}s less than $cmax: " . join(' ', tuple_tail(5,$cnt,@{$primes{$sexy}})) . "\n";
    print "\n";
}

print "Number of unsexy primes less than $cmax: ". comma(scalar @{$primes{unsexy}}) . "\n";
print "  Last 10 unsexy primes less than $cmax: ". join(' ', @{$primes{unsexy}}[-10..-1]) . "\n";
