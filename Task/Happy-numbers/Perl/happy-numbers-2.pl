use List::Util qw(sum);
sub is_happy {
    my ($n) = @_;
    my %seen;
    while (1) {
        $n = sum map { $_ ** 2 } split //, $n;
        return 1 if $n == 1;
        return 0 if $seen{$n}++;
    }
}

my $n;
is_happy( ++$n ) and print "$n " or redo for 1..8;
