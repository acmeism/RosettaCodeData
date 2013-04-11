my $d7 = 1..7;
sub roll7 { $d7.roll };

my $threshold = 3;

for 14, 105, 1001, 10003, 100002, 1000006 ->  $n
  { dist( $n, $threshold,  &roll7 ) };


sub dist ( $n is copy, $threshold, &producer ) {
    my @dist;
    my $expect = $n / 7;
    say "Expect\t",$expect.fmt("%.3f");

    loop ($_ = $n; $n; --$n) { @dist[&producer()]++; }

    for @dist.kv -> $i, $v is copy {
        next unless $i;
        $v //= 0;
        my $pct = ($v - $expect)/$expect*100;
        printf "%d\t%d\t%+.2f%% %s\n", $i, $v, $pct,
          ($pct.abs > $threshold ?? '- skewed' !! '');
    }
    say '';
}
