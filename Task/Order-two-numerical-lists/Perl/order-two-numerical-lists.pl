use strict;
use warnings;

sub orderlists {
    my ($firstlist, $secondlist) = @_;

    my ($first, $second);
    while (@{$firstlist}) {
        $first = shift @{$firstlist};
        if (@{$secondlist}) {
            $second = shift @{$secondlist};
            if ($first < $second) {
                return 1;
            }
            if ($first > $second) {
                return 0;
            }
        }
        else {
            return 0;
        }
    }

    @{$secondlist} ? 1 : 0;
}

foreach my $pair (
    [[1, 2, 4], [1, 2, 4]],
    [[1, 2, 4], [1, 2,  ]],
    [[1, 2,  ], [1, 2, 4]],
    [[55,53,1], [55,62,83]],
    [[20,40,51],[20,17,78,34]],
) {
    my $first  = $pair->[0];
    my $second = $pair->[1];
    my $before = orderlists([@$first], [@$second]) ? 'true' : 'false';
    print "(@$first) comes before (@$second) : $before\n";
}
