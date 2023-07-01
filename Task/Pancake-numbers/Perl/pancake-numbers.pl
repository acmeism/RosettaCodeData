use strict;
use warnings;
use feature 'say';

sub pancake {
    my($n) = @_;
    my ($gap, $sum, $adj) = (2, 2, -1);
    while ($sum < $n) { $sum += $gap = $gap * 2 - 1 and $adj++ }
    $n + $adj;
}

my $out;
$out .= sprintf "p(%2d) = %2d ", $_, pancake $_ for 1..20;
say $out =~ s/.{1,55}\K /\n/gr;

# Maximum number of flips plus examples using exhaustive search
sub pancake2 {
    my ($n) = @_;
    my $numStacks = 1;
    my @goalStack = 1 .. $n;
    my %newStacks = my %stacks = (join(' ',@goalStack), 0);
    for my $k (1..1000) {
        my %nextStacks;
        for my $pos (2..$n) {
            for my $key (keys %newStacks) {
                my @arr = split ' ', $key;
                my $cakes = join ' ', (reverse @arr[0..$pos-1]), @arr[$pos..$#arr];
                $nextStacks{$cakes} = $k unless $stacks{$cakes};
            }
        }
        %stacks = (%stacks, (%newStacks = %nextStacks));
        my $perms    = scalar %stacks;
        my %inverted = reverse %stacks;
        return $k-1, $inverted{(sort keys %inverted)[-1]} if $perms == $numStacks;
        $numStacks = $perms;
   }
}

say "\nThe maximum number of flips to sort a given number of elements is:";
for my $n (1..9) {
    my ($a,$b) = pancake2($n);
    say "pancake($n) = $a example: $b";
}
