sub roll7 { 1+int rand(7) }
sub roll5 { 1+int rand(5) }
sub roll7_5 {
  while(1) {
    my $d7 = (5*&roll5 + &roll5 - 6) % 8;
    return $d7 if $d7;
  }
}

my $threshold = 5;

print dist( $_, $threshold,  \&roll7   ) for <1001 1000006>;
print dist( $_, $threshold,  \&roll7_5 ) for <1001 1000006>;

sub dist {
my($n, $threshold, $producer) = @_;
    my @dist;
    my $result;
    my $expect = $n / 7;
    $result .= sprintf "%10d expected\n", $expect;

    for (1..$n) { @dist[&$producer]++; }

    for my $i (1..7) {
        my $v = @dist[$i];
        my $pct = ($v - $expect)/$expect*100;
        $result .= sprintf "%d %8d %6.1f%%%s\n", $i, $v, $pct, (abs($pct) > $threshold ? ' - skewed' : '');
    }
    return $result . "\n";
}
