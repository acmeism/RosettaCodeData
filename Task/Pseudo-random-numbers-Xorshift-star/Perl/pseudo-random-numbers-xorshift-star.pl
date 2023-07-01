use strict;
use warnings;
no warnings 'portable';
use feature 'say';
use Math::AnyNum qw(:overload);

package Xorshift_star {

    sub new {
        my ($class, %opt) = @_;
        bless {state => $opt{seed}}, $class;
    }

    sub next_int {
        my ($self) = @_;
        my $state = $self->{state};
        $state ^= $state >> 12;
        $state ^= $state << 25 & (2**64 - 1);
        $state ^= $state >> 27;
        $self->{state} = $state;
        ($state * 0x2545F4914F6CDD1D) >> 32 & (2**32 - 1);
    }

    sub next_float {
        my ($self) = @_;
        $self->next_int / 2**32;
    }
}

say 'Seed: 1234567, first 5 values:';
my $rng = Xorshift_star->new(seed => 1234567);
say $rng->next_int for 1 .. 5;

my %h;
say "\nSeed: 987654321, values histogram:";
$rng = Xorshift_star->new(seed => 987654321);
$h{int 5 * $rng->next_float}++ for 1 .. 100_000;
say "$_ $h{$_}" for sort keys %h;
