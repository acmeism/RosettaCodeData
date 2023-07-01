use strict;
use warnings;
no warnings 'uninitialized';
use feature 'say';
use constant True => 1;
use List::Util qw(head uniq);

sub GraphNodeColor {
    my(%OneMany, %NodeColor, %NodePool, @ColorPool);
    my(@data) = @_;

    for (@data) {
        my($a,$b) = @$_;
        push @{$OneMany{$a}}, $b;
        push @{$OneMany{$b}}, $a;
    }

    @ColorPool = 0 .. -1 + scalar %OneMany;
    $NodePool{$_} = True for keys %OneMany;

    if ($OneMany{''}) { # skip islanders for now
        delete $NodePool{$_} for @{$OneMany{''}};
        delete $NodePool{''};
    }

    while (%NodePool) {
        my $color = shift @ColorPool;
        my %TempPool = %NodePool;

        while (my $n = head 1, sort keys %TempPool) {
            $NodeColor{$n} = $color;
            delete $TempPool{$n};
            delete $TempPool{$_} for @{$OneMany{$n}} ; # skip neighbors as well
            delete $NodePool{$n};
        }

        if ($OneMany{''}) { # islanders use an existing color
            $NodeColor{$_} = head 1, sort values %NodeColor for @{$OneMany{''}};
        }
    }
    %NodeColor
}

my @DATA = (
    [ [1,2],[2,3],[3,1],[4,undef],[5,undef],[6,undef] ],
    [ [1,6],[1,7],[1,8],[2,5],[2,7],[2,8],[3,5],[3,6],[3,8],[4,5],[4,6],[4,7] ],
    [ [1,4],[1,6],[1,8],[3,2],[3,6],[3,8],[5,2],[5,4],[5,8],[7,2],[7,4],[7,6] ],
    [ [1,6],[7,1],[8,1],[5,2],[2,7],[2,8],[3,5],[6,3],[3,8],[4,5],[4,6],[4,7] ]
);

for my $d (@DATA) {
    my %result = GraphNodeColor @$d;

    my($graph,$colors);
    $graph  .= '(' . join(' ', @$_) . '), ' for @$d;
    $colors .= ' ' . $result{$$_[0]} . '-' . ($result{$$_[1]} // '') . '   ' for @$d;

    say 'Graph  : ' . $graph =~ s/,\s*$//r;
    say 'Colors : ' . $colors;
    say 'Nodes  : ' . keys %result;
    say 'Edges  : ' . @$d;
    say 'Unique : ' . uniq values %result;
    say '';
}
