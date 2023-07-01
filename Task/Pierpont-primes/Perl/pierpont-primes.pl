use strict;
use warnings;
use feature 'say';
use bigint try=>"GMP";
use ntheory qw<is_prime>;

# index of mininum value in list
sub min_index { my $b = $_[my $i = 0]; $_[$_] < $b && ($b = $_[$i = $_]) for 0..$#_; $i }

sub iter1 { my $m = shift; my $e = 0; return sub { $m ** $e++;    } }
sub iter2 { my $m = shift; my $e = 1; return sub { $m * ($e *= 2) } }

sub pierpont {
    my($max ) = shift || die 'Must specify count of primes to generate.';
    my($kind) = @_ ? shift : 1;
    die "Unknown type: $kind. Must be one of 1 (default) or 2" unless $kind == 1 || $kind == 2;
    $kind = -1 if $kind == 2;

    my $po3     = 3;
    my $add_one = 3;
    my @iterators;
    push @iterators, iter1(2);
    push @iterators, iter1(3); $iterators[1]->();
    my @head = ($iterators[0]->(), $iterators[1]->());

    my @pierpont;
    do {
        my $key = min_index(@head);
        my $min = $head[$key];
        push @pierpont, $min + $kind if is_prime($min + $kind);

        $head[$key] = $iterators[$key]->();

        if ($min >= $add_one) {
            push @iterators, iter2($po3);
            $add_one = $head[$#iterators] = $iterators[$#iterators]->();
            $po3 *= 3;
        }
    } until @pierpont == $max;
    @pierpont;
}

my @pierpont_1st = pierpont(250,1);
my @pierpont_2nd = pierpont(250,2);

say "First 50 Pierpont primes of the first kind:";
my $fmt = "%9d"x10 . "\n";
for my $row (0..4) { printf $fmt, map { $pierpont_1st[10*$row + $_] } 0..9 }
say "\nFirst 50 Pierpont primes of the second kind:";
for my $row (0..4) { printf $fmt, map { $pierpont_2nd[10*$row + $_] } 0..9 }

say "\n250th Pierpont prime of the first kind:    " . $pierpont_1st[249];
say "\n250th Pierpont prime of the second kind: "   . $pierpont_2nd[249];
