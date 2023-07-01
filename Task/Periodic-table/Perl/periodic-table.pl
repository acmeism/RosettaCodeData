use strict;
use warnings; no warnings 'uninitialized';
use feature 'say';
use List::Util <sum head>;

sub divmod { int $_[0]/$_[1], $_[0]%$_[1] }

my $b = 18;
my(@offset,@span,$cnt);
push @span, ($cnt++) x $_ for <1 3 8 44 15 17 15 15>;
@offset = (16, 10, 10, (2*$b)+1, (-2*$b)-15, (2*$b)+1, (-2*$b)-15);

for my $n (<1 2 29 42 57 58 72 89 90 103 118>) {
    printf "%3d: %2d, %2d\n", $n, map { $_+1 } divmod $n-1 + sum(head $span[$n-1], @offset), $b;
}
