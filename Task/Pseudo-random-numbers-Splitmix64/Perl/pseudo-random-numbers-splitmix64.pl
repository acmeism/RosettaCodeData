use strict;
use warnings;
no warnings 'portable';
use feature 'say';
use Math::AnyNum qw(:overload);

package splitmix64 {

    sub new {
        my ($class, %opt) = @_;
        bless {state => $opt{seed}}, $class;
    }

    sub next_int {
        my ($self) = @_;
        my $next = $self->{state} = ($self->{state} + 0x9e3779b97f4a7c15) & (2**64 - 1);
        $next = ($next ^ ($next >> 30)) * 0xbf58476d1ce4e5b9 & (2**64 - 1);
        $next = ($next ^ ($next >> 27)) * 0x94d049bb133111eb & (2**64 - 1);
        ($next ^ ($next >> 31)) & (2**64 - 1);
    }

    sub next_float {
        my ($self) = @_;
        $self->next_int / 2**64;
    }
}

say 'Seed: 1234567, first 5 values:';
my $rng = splitmix64->new(seed => 1234567);
say $rng->next_int for 1 .. 5;

my %h;
say "\nSeed: 987654321, values histogram:";
$rng = splitmix64->new(seed => 987654321);
$h{int 5 * $rng->next_float}++ for 1 .. 100_000;
say "$_ $h{$_}" for sort keys %h;
