use 5.020_000; # Also turns on `strict`
use warnings;
use experimental qw<signatures>;
use Data::Dump   qw<pp>;

sub new_level ( $stack ) {
    my $e = [];
    push @{ $stack->[-1] }, $e;
    push @{ $stack       }, $e;
}
sub to_tree_iterative ( @xs ) {
    my $nested = [];
    my $stack  = [$nested];

    for my $x (@xs) {
        new_level($stack) while $x > @{$stack};
        pop     @{$stack} while $x < @{$stack};
        push    @{$stack->[-1]},$x;
    }

    return $nested;
}
my @tests = ([],[1,2,4],[3,1,3,1],[1,2,3,1],[3,2,1,3],[3,3,3,1,1,3,3,3]);
say sprintf('%15s => ', join(' ', @{$_})), pp(to_tree_iterative(@{$_})) for @tests;
