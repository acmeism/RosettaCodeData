use strict;
use warnings;
use List::Util 'min';

#use bigint     # works, but slow
use Math::GMPz; # this module gives roughly 16x speed-up

sub humble_gen {
    my @s = ([1], [1], [1], [1]);
    my @m = (2, 3, 5, 7);
    @m = map { Math::GMPz->new($_) } @m; # comment out to NOT use Math::GMPz

    return sub {
    my $n = min $s[0][0], $s[1][0], $s[2][0], $s[3][0];
    for (0..3) {
            shift @{$s[$_]} if $s[$_][0] == $n;
            push @{$s[$_]}, $n * $m[$_]
        }
        return $n
    }
}

my $h = humble_gen;
my $i = 0;
my $upto = 50;

my $list;
++$i, $list .= $h->(). " " until $i == $upto;
print "$list\n";

$h = humble_gen; # from the top...
my $count  = 0;
my $digits = 1;

while ($digits <= $upto) {
    ++$count and next if $digits == length $h->();
    printf "Digits: %2d - Count: %s\n", $digits++, $count;
    $count = 1;
}
