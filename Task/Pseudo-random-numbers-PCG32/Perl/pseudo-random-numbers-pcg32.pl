use strict;
use warnings;
use feature 'say';
use Math::AnyNum qw(:overload);

package PCG32 {

    use constant {
        mask32 => 2**32 - 1,
        mask64 => 2**64 - 1,
        const  => 6364136223846793005,
    };

    sub new {
        my ($class, %opt) = @_;
        my $seed = $opt{seed} // 1;
        my $incr = $opt{incr} // 2;
        $incr = $incr << 1 | 1 & mask64;
        my $state = (($incr + $seed) * const + $incr) & mask64;
        bless {incr => $incr, state => $state}, $class;
    }

    sub next_int {
        my ($self) = @_;
        my $state  = $self->{state};
        my $shift  = ($state >> 18 ^ $state) >> 27 & mask32;
        my $rotate = $state >> 59 & mask32;
        $self->{state} = ($state * const + $self->{incr}) & mask64;
        ($shift >> $rotate) | $shift << (32 - $rotate) & mask32;
    }

    sub next_float {
        my ($self) = @_;
        $self->next_int / 2**32;
    }
}

say "Seed: 42, Increment: 54, first 5 values:";
my $rng = PCG32->new(seed => 42, incr => 54);
say $rng->next_int for 1 .. 5;

say "\nSeed: 987654321, Increment: 1, values histogram:";
my %h;
$rng = PCG32->new(seed => 987654321, incr => 1);
$h{int 5 * $rng->next_float}++ for 1 .. 100_000;
say "$_ $h{$_}" for sort keys %h;
