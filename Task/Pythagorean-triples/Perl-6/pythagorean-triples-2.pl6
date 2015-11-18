my %triples;
my $limit = 10000;

for 3 .. $limit/2 -> $c {
   for 1 .. $c -> $a {
       my $b = ($c * $c - $a * $a).sqrt;
       last if $c + $a + $b > $limit;
       last if $a > $b;
       if $b == $b.Int {
          my $key = "$a $b $c";
          %triples{$key} = ([gcd] $c, $a, $b.Int) > 1 ?? 0  !! 1;
          say $key, %triples{$key} ?? ' - primitive' !! '';
       }
   }
}

say "There are {+%triples.keys} Pythagorean Triples with a perimeter <= $limit,"
 ~"\nof which {[+] %triples.values} are primitive.";
