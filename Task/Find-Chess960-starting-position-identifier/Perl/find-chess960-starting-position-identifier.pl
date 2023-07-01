use v5.36;
use List::AllUtils 'indexes';

sub sp_id ($setup) {
    8 == length $setup                          or return 'Illegal position: should have exactly eight pieces';
    1 == @{[ $setup =~ /$_/g ]}                 or return "Illegal position: should have exactly one $_"        for <K Q>;
    2 == @{[ $setup =~ /$_/g ]}                 or return "Illegal position: should have exactly two $_\'s"     for <B N R>;
    $setup =~ m/R .* K .* R/x                   or return 'Illegal position: King not between rooks.';
    index($setup,'B')%2 != rindex($setup,'B')%2 or return 'Illegal position: Bishops not on opposite colors.';

    my @knights = indexes { 'N' eq $_ } split '', $setup =~ s/[QB]//gr;
    my $knight  = indexes { join('', @knights) eq $_ } <01 02 03 04 12 13 14 23 24 34>; # combinations(5,2)
    my @bishops = indexes { 'B' eq $_ } split '', $setup;
    my $dark    = int ((grep { $_ % 2 == 0 } @bishops)[0]) / 2;
    my $light   = int ((grep { $_ % 2 == 1 } @bishops)[0]) / 2;
    my $queen   = index(($setup =~ s/B//gr), 'Q');

    int 4*(4*(6*$knight + $queen)+$dark)+$light;
}

say "$_ " . sp_id($_) for <QNRBBNKR RNBQKBNR RQNBBKRN RNQBBKRN QNBRBNKR>;
