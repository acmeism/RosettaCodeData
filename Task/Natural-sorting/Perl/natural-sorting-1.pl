use feature 'fc';
use Unicode::Normalize;

sub natural_sort {
    my @items = map {
        my $str = fc(NFKD($_));
        $str =~ s/\s+/ /;
        $str =~ s/|^(?:the|a|an) \b|\p{Nonspacing_Mark}| $//g;
        my @fields = $str =~ /(?!\z) ([^0-9]*+) ([0-9]*+)/gx;
        [$_, \@fields]
    } @_;
    return map { $_->[0] } sort {
        my @x = @{$a->[1]};
        my @y = @{$b->[1]};
        my $numeric;
        while (@x && @y) {
            my ($x, $y) = (shift @x, shift @y);
            return (($numeric = !$numeric) ? $x cmp $y : $x <=> $y or next);
        }
        return @x <=> @y;
    } @items;
}
