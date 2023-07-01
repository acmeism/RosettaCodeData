use strict;
use warnings;
use feature 'say';

package MRG32k3a {

    use constant {
        m1 => 2**32 - 209,
        m2 => 2**32 - 22853
    };

    use Const::Fast;
    const my @a1 => <     0 1403580  -810728>;
    const my @a2 => <527612       0 -1370589>;

    sub new {
        my ($class,undef,$seed) = @_;
        my @x1 = my @x2 = ($seed, 0, 0);
        bless {x1 => \@x1, x2 => \@x2}, $class;
    }

    sub next_int {
        my ($self) = @_;
        unshift @{$$self{x1}}, ($a1[0] * $$self{x1}[0] + $a1[1] * $$self{x1}[1] + $a1[2] * $$self{x1}[2]) % m1; pop @{$$self{x1}};
        unshift @{$$self{x2}}, ($a2[0] * $$self{x2}[0] + $a2[1] * $$self{x2}[1] + $a2[2] * $$self{x2}[2]) % m2; pop @{$$self{x2}};
        ($$self{x1}[0] - $$self{x2}[0]) % (m1 + 1)
    }

    sub next_float { $_[0]->next_int / (m1 + 1) }
}

say 'Seed: 1234567, first 5 values:';
my $rng = MRG32k3a->new( seed => 1234567 );
say $rng->next_int for 1..5;

my %h;
say "\nSeed: 987654321, values histogram:";
$rng = MRG32k3a->new( seed => 987654321 );
$h{int 5 * $rng->next_float}++ for 1..100_000;
say "$_ $h{$_}" for sort keys %h;
