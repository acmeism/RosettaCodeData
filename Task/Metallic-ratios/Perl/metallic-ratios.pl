use strict;
use warnings;
use feature qw(say state);
use Math::AnyNum qw<:overload as_dec>;

sub gen_lucas {
    my $b = shift;
    my $i = 0;
    return sub {
        state @seq = (state $v1 = 1, state $v2 = 1);
        ($v2, $v1) = ($v1, $v2 + $b*$v1) and push(@seq, $v1) unless defined $seq[$i+1];
        return $seq[$i++];
    }
}

sub metallic {
    my $lucas  = shift;
    my $places = shift || 32;
    my $n = my $last = 0;
    my @seq = $lucas->();
    while (1) {
        push @seq, $lucas->();
        my $this = as_dec( $seq[-1]/$seq[-2], $places+1 );
        last if $this eq $last;
        $last = $this;
        $n++;
    }
    $last, $n
}

my @name = <Platinum Golden Silver Bronze Copper Nickel Aluminum Iron Tin Lead>;

for my $b (0..$#name) {
    my $lucas = gen_lucas($b);
    printf "\n'Lucas' sequence for $name[$b] ratio, where b = $b:\nFirst 15 elements: " . join ', ', map { $lucas->() } 1..15;
    printf "Approximated value %s reached after %d iterations\n", metallic(gen_lucas($b));
}

printf "\nGolden ratio to 256 decimal places %s reached after %d iterations", metallic(gen_lucas(1),256);
