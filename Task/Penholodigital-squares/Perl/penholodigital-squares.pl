use v5.36;
use List::Util 'max';
use ntheory <fromdigits todigitstring>;

sub table ($c, @V) { my $t = $c * (my $w = 2 + max map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

for my $base (9 .. 12) {
    my $testr = reverse my $test = substr('123456789abcdef',0,$base-1);
    my $start = int sqrt fromdigits($test,  $base);
    my $end   = int sqrt fromdigits($testr, $base);
    my @nums = grep { $test eq join '', sort split '', todigitstring($_**2, $base) } $start .. $end;
    printf "There are a total of %d penholodigital squares in base $base:\n", scalar @nums;
    say table 4, map { todigitstring($_,$base) . '² = ' . todigitstring($_**2,$base) } @nums;
}
