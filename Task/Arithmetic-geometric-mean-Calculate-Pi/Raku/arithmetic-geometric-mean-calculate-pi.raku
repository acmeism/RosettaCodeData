constant number-of-decimals = 100;

multi sqrt(Int $n) {
  (10**($n.chars div 2), { ($_ + $n div $_) div 2 } ... * == *).tail
}

multi sqrt(FatRat $r --> FatRat) {
  return FatRat.new:
    sqrt($r.numerator * 10**(number-of-decimals*2) div $r.denominator),
    10**number-of-decimals;
}

my FatRat ($a, $n) = 1.FatRat xx 2;
my FatRat $g = sqrt(1/2.FatRat);
my $z = .25;

for ^10 {
  given [ ($a + $g)/2, sqrt($a * $g) ] {
    $z -= (.[0] - $a)**2 * $n;
    $n += $n;
    ($a, $g) = @$_;
    say ($a ** 2 / $z).substr: 0, 2 + number-of-decimals;
  }
}
