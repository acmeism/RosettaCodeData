my($beg, $end) = (@ARGV==0) ? (1,25) : (@ARGV==1) ? (1,shift) : (shift,shift);

my $lim = 1e14;  # Ought to be dynamic as should segment size
my @basis = map { $_*$_*$_ } (1 .. int($lim ** (1.0/3.0) + 1));
my $paira = 2;  # We're looking for Ta(2) and larger

my ($segsize, $low, $high, $i) = (500_000_000, 0, 0, 0);

while ($i < $end) {
  $low = $high+1;
  die "lim too low" if $low > $lim;
  $high = $low + $segsize - 1;
  $high = $lim if $high > $lim;
  foreach my $p (_find_pairs_segment(\@basis, $paira, $low, $high,
                 sub { sprintf("%4d^3 + %4d^3", $_[0], $_[1]) })    ) {
    $i++;
    next if $i < $beg;
    last if $i > $end;
    my $n = shift @$p;
    printf "%4d: %10d  = %s\n", $i, $n, join("  = ", @$p);
  }
}

sub _find_pairs_segment {
  my($p, $len, $start, $end, $formatsub) = @_;
  my $plen = $#$p;

  my %allpairs;
  foreach my $i (0 .. $plen) {
    my $pi = $p->[$i];
    next if ($pi+$p->[$plen]) < $start;
    last if (2*$pi) > $end;
    foreach my $j ($i .. $plen) {
      my $sum = $pi + $p->[$j];
      next if $sum < $start;
      last if $sum > $end;
      push @{ $allpairs{$sum} }, $i, $j;
    }
    # If we wanted to save more memory, we could filter and delete every entry
    # where $n < 2 * $p->[$i+1].  This can cut memory use in half, but is slow.
  }

  my @retlist;
  foreach my $list (grep { scalar @$_ >= $len*2 } values %allpairs) {
    my $n = $p->[$list->[0]] + $p->[$list->[1]];
    my @pairlist;
    while (@$list) {
      push @pairlist, $formatsub->(1 + shift @$list, 1 + shift @$list);
    }
    push @retlist, [$n, @pairlist];
  }
  @retlist = sort { $a->[0] <=> $b->[0] } @retlist;
  return @retlist;
}
