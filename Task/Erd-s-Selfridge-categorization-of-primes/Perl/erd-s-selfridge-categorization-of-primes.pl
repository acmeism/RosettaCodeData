use strict;
use warnings;
use feature 'say';
use List::Util 'max';
use ntheory qw/factor/;
use Primesieve qw(generate_primes);

my @primes = (0, generate_primes (1, 10**8));
my %cat = (2 => 1, 3 => 1);

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub ES {
    my ($n) = @_;
    my @factors = factor $n + 1;
    my $category = max map { defined $cat{$_} and $cat{$_} } @factors;
    unless (defined $cat{ $factors[-1] }) {
        $category = max $category, (1 + max map { $cat{$_} } factor 1 + $factors[-1]);
        $cat{ $factors[-1] } = $category;
    }
    $category
}

my %es;
my $upto = 200;
push @{$es{ES($_)}}, $_ for @primes[1..$upto];
say "First $upto primes, Erdös-Selfridge categorized:";
say "$_: " . join ' ', sort {$a <=> $b} @{$es{$_}} for sort keys %es;

%es = ();
$upto = 1_000_000;
say "\nSummary of first @{[comma $upto]} primes, Erdös-Selfridge categorized:";
push @{$es{ES($_)}}, $_ for @primes[1..$upto];
printf "Category %2d:  first: %9s  last: %10s  count: %s\n",
    map { comma $_ } $_, (sort {$a <=> $b} @{$es{$_}})[0, -1], scalar @{$es{$_}}
        for sort {$a <=> $b} keys %es;
