use strict;
use warnings;
use feature 'say';

sub van_eck {
    my($init,$max) = @_;
    my(%v,$k);
    my @V = my $i = $init;
    for (1..$max) {
        $k++;
        my $t  = $v{$i} ? $k - $v{$i} : 0;
        $v{$i} = $k;
        push @V, $i = $t;
    }
    @V;
}

for (
    ['A181391', 0],
    ['A171911', 1],
    ['A171912', 2],
    ['A171913', 3],
    ['A171914', 4],
    ['A171915', 5],
    ['A171916', 6],
    ['A171917', 7],
    ['A171918', 8],
) {
    my($seq, $start) = @$_;
    my @seq = van_eck($start,1000);
    say <<~"END";
    Van Eck sequence OEIS:$seq; with the first term: $start
            First 10 terms: @{[@seq[0  ..  9]]}
    Terms 991 through 1000: @{[@seq[990..999]]}
    END
}
