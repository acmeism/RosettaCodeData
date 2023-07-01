use strict;
use warnings;
use feature 'say';
use Set::Scalar;
use Set::Bag;
use Storable qw(dclone);

sub show { my($pts) = @_; my $p='( '; $p .= '(' . join(' ',@$_) . ') ' for @$pts; $p.')' }

sub check_equivalence {
    my($a, $b) = @_;
    Set::Scalar->new(@$a) == Set::Scalar->new(@$b)
}

sub edge_to_periphery {
    my $a = dclone \@_;

    my $bag_a = Set::Bag->new;
    for my $p (@$a) {
        $bag_a->insert( @$p[0] => 1);
        $bag_a->insert( @$p[1] => 1);
    }
    2 != @$bag_a{$_} and return 0 for keys %$bag_a;

    my $b = shift @$a;
    while ($#{$a} > 0) {
        for my $k (0..$#{$a}) {
            my $v = @$a[$k];
            if (@$v[0] == @$b[-1]) {
                push @$b, @$v[1];
                splice(@$a,$k,1);
                last
            } elsif (@$v[1] == @$b[-1]) {
                push @$b, @$v[0];
                splice(@$a,$k,1);
                last
            }
        }
    }
    @$b;
}

say 'Perimeter format equality checks:';
for ([[8, 1, 3], [1, 3, 8]],
     [[18, 8, 14, 10, 12, 17, 19], [8, 14, 10, 12, 17, 19, 18]]) {
    my($a, $b) = @$_;
    say '(' . join(', ', @$a) . ')  equivalent to  (' . join(', ', @$b) . ')? ',
        check_equivalence($a, $b) ? 'True' : 'False';
}

say "\nEdge to perimeter format translations:";
for ([[1, 11], [7, 11], [1, 7]],
     [[11, 23], [1, 17], [17, 23], [1, 11]],
     [[8, 14], [17, 19], [10, 12], [10, 14], [12, 17], [8, 18], [18, 19]],
     [[1, 3], [9, 11], [3, 11], [1, 11]]) {
    say show($_) . '  ==>  (' .  (join ' ', edge_to_periphery(@$_) or 'Invalid edge format') . ')'
}
