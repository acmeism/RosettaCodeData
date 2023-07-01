use v5.36;
use experimental 'for_list';
use ntheory <factor todigitstring>;
use List::Util <sum max min pairmap>;

sub table ($c, @V) { my $t = $c * (my $w = 6); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub bag (@v) { my %h; $h{$_}++ for @v; %h }

for my $base (10, 11) {
    my(@F,@E,@W,$n,$totals);
    do {
        my %F = bag factor ++$n;
        my $s = sum pairmap { length(todigitstring($a,$base)) + ($b > 1 ? length(todigitstring($b,$base)) : 0) } %F;
        my $l = length todigitstring($n,$base);
        if    ($n == 1 or $l == $s) { push @E, $n }
        elsif (           $l <  $s) { push @W, $n }
        else                        { push @F, $n }
    } until 10000 < min scalar @F, scalar @E, scalar @W;

    say "In base $base:";
    for my ($type, $values) ('Wasteful', \@W, 'Equidigital', \@E, 'Frugal', \@F) {
        say "\n$type numbers:";
        say table 10, @$values[0..49];
        say "10,000th: $$values[9999]";
        $totals .= sprintf "%11s: %d\n", $type, scalar grep { $_ < 1_000_000 } @$values
    }
    say "\nOf the positive integers up to one million:\n$totals";
}
