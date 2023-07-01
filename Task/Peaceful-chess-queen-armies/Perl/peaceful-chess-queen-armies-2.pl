use strict;
use warnings;
use feature 'say';
use feature 'state';
use utf8;
binmode(STDOUT, ':utf8');

# recursively place the next queen
sub place {
    my($board, $n, $m, $empty_square) = @_;
    state(%seen,$attack,$solution);

    # logic of 'attack' regex: queen ( ... paths between queens containing only empty squares ... ) queen of other color
    unless ($attack) {
      $attack =
        '([WB])' .      # 1st queen
        '(?:' .
            join('|',
                "[$empty_square]*",
                map {
                    "(?^s:.{$_}(?:[$empty_square].{$_})*)"
                } $n-1, $n, $n+1
            ) .
        ')' .
        '(?!\1)[WB]';   # 2nd queen
    }

    # pass first result found back up the stack (omit this line to get last result found)
    return $solution if $solution;

    # bail out if seen this configuration previously, or attack detected
    return if $seen{$board}++ or $board =~ /$attack/;

    # success if queen count is m×2
    $solution = $board and return if $m * 2 == (my $have = $board =~ tr/WB//);

    # place the next queen (alternating colors each time)
    place(   $board =~ s/[$empty_square]\G/ qw<W B>[$have % 2] /er, $n, $m, $empty_square )
       while $board =~  /[$empty_square]/g;

    return $solution
}

my($m, $n) = $#ARGV == 1 ? @ARGV : (4, 5);
my $empty_square = '◦•';
my $board = join "\n", map { substr $empty_square x $n, $_%2, $n } 1..$n;

my $solution = place $board, $n, $m, $empty_square;

say $solution
    ? sprintf "Solution to $m $n\n\n%s", map { s/(.)/$1 /gm; s/B /♛/gm; s/W /♕/gmr } $solution
    : "No solution to $m $n";
