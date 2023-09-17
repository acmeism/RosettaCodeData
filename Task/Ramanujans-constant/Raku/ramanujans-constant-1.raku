use Rat::Precise;

# set the degree of precision for calculations
constant D = 54;
constant d = 15;

# two versions of exponentiation where base and exponent are both FatRat
multi infix:<**> (FatRat $base, FatRat $exp where * >= 1 --> FatRat) {
    2 R** $base**($exp/2);
}

multi infix:<**> (FatRat $base, FatRat $exp where * <  1 --> FatRat) {
    constant ε = 10**-D;
    my $low  = 0.FatRat;
    my $high = 1.FatRat;
    my $mid  = $high / 2;
    my $acc  = my $sqr = sqrt($base);

    while (abs($mid - $exp) > ε) {
      $sqr = sqrt($sqr);
      if ($mid <= $exp) { $low  = $mid; $acc ×=   $sqr }
      else              { $high = $mid; $acc ××= 1/$sqr }
      $mid = ($low + $high) / 2;
    }
    $acc.substr(0, D).FatRat;
}

# calculation of π
sub π (--> FatRat) {
    my ($a, $n) = 1, 1;
    my $g = sqrt 1/2.FatRat;
    my $z = .25;
    my $pi;

    for ^d {
        given [ ($a + $g)/2, sqrt $a × $g ] {
            $z -= (.[0] - $a)**2 × $n;
            $n += $n;
            ($a, $g) = @$_;
            $pi = ($a ** 2 / $z).substr: 0, 2 + D;
        }
    }
    $pi.FatRat;
}

multi sqrt(FatRat $r --> FatRat) {
    FatRat.new: sqrt($r.nude[0] × 10**(D×2) div $r.nude[1]), 10**D;
}

# integer roots
multi sqrt(Int $n) {
    my $guess = 10**($n.chars div 2);
    my $iterator = { ( $^x + $n div ($^x) ) div 2 };
    my $endpoint = { $^x == $^y|$^z };
    min ($guess, $iterator … $endpoint)[*-1, *-2];
}

# 'cosmetic' cover to upgrade input to FatRat sqrt
sub prefix:<√> (Int $n) { sqrt($n.FatRat) }

# calculation of 𝑒
sub postfix:<!> (Int $n) { (constant f = 1, |[\×] 1..*)[$n] }
sub 𝑒 (--> FatRat) { sum map { FatRat.new(1,.!) }, ^D }

# inputs, and their difference, formatted decimal-aligned
sub format ($a,$b) {
    sub pad ($s) { ' ' x ((34 - d - 1) - ($s.split(/\./)[0]).chars) }
    my $c = $b.precise(d, :z);
    my $d = ($a-$b).precise(d, :z);
    join "\n",
        (sprintf "%11s {pad($a)}%s\n", 'Int', $a) ~
        (sprintf "%11s {pad($c)}%s\n", 'Heegner', $c) ~
        (sprintf "%11s {pad($d)}%s\n", 'Difference', $d)
}

# override built-in definitions
constant π = &π();
constant 𝑒 = &𝑒();

my $Ramanujan = 𝑒**(π × √163);
say "Ramanujan's constant to 32 decimal places:\nActual:     " ~
    "262537412640768743.99999999999925007259719818568888\n" ~
    "Calculated: ", $Ramanujan.precise(32, :z), "\n";

say "Heegner numbers yielding 'almost' integers";
for 19, 96, 43, 960, 67, 5280, 163, 640320 -> $heegner, $x {
    my $almost = 𝑒**(π × √$heegner);
    my $exact  = $x³ + 744;
    say format($exact, $almost);
}
