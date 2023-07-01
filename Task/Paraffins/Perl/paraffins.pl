use Math::GMPz;

my $nmax = 250;
my $nbranches = 4;

my @rooted   = map { Math::GMPz->new($_) } 1,1,(0) x $nmax;
my @unrooted = map { Math::GMPz->new($_) } 1,1,(0) x $nmax;
my @c        = map { Math::GMPz->new(0) } 0 .. $nbranches-1;

sub tree {
  my($br, $n, $l, $sum, $cnt) = @_;
  for my $b ($br+1 .. $nbranches) {
    $sum += $n;
    return if $sum > $nmax || ($l*2 >= $sum && $b >= $nbranches);
    if ($b == $br+1) {
      $c[$br] = $rooted[$n] * $cnt;
    } else {
      $c[$br] *= $rooted[$n] + $b - $br - 1;
      $c[$br] /= $b - $br;
    }
    $unrooted[$sum] += $c[$br] if $l*2 < $sum;
    return if $b >= $nbranches;
    $rooted[$sum] += $c[$br];
    for my $m (reverse 1 .. $n-1) {
      next if $sum+$m > $nmax;
      tree($b, $m, $l, $sum, $c[$br]);
    }
  }
}

sub bicenter {
  my $s = shift;
  $unrooted[$s] += $rooted[$s/2] * ($rooted[$s/2]+1) / 2  unless $s & 1;
}

for my $n (1 .. $nmax) {
  tree(0, $n, $n, 1, Math::GMPz->new(1));
  bicenter($n);
  print "$n: $unrooted[$n]\n";
}
