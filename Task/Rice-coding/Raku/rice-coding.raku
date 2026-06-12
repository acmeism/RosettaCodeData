package Rice {

  our sub encode(Int $n, UInt :$k = 2) {
    my $d = 2**$k;
    my $q = $n div $d;
    my $b = sign(1 + sign($q));
    my $m = abs($q) + $b;
    flat
      $b xx $m, 1 - $b,
      ($n mod $d).polymod(2 xx $k - 1).reverse
  }

  our sub decode(@bits is copy, UInt :$k = 2) {
    my $d = 2**$k;
    my $b = @bits.shift;
    my $m = 1;
    $m++ while @bits and @bits.shift == $b;
    my $q = $b ?? $m - 1 !! -$m;
    $q*$d + @bits.reduce(2 * * + *);
  }

}

CHECK {
  use Test;
  constant N = 100;
  plan 2*N + 1;
  is $_, Rice::decode Rice::encode $_ for -N..N;
}
