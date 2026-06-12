use Prime::Factor;

sub Zsigmondy ($a, $b) {
    my @aexp = 1, * × $a … *;
    my @bexp = 1, * × $b … *;
    (1..∞).map: -> $n {
        (@aexp[$n] - @bexp[$n]).&divisors.sort(-*).first: -> $d {
            all (1..^$n).map: { (@aexp[$_] - @bexp[$_]) gcd $d == 1 }
        }
    }
}

for '064078', (2,1), '064079', (3,1), '064080', (4,1), '064081', (5,1), '064082', (6,1),
    '064083', (7,1), '109325', (3,2), '109347', (5,3), '109348', (7,3), '109349', (7,5)
  -> $oeis, $seq {
    say "\nA$oeis: Zsigmondy(n,$seq[0],$seq[1]):\n" ~ Zsigmondy(|$seq)[^20]
}
