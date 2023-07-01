my $limit = 10000;
my atomicint $i = 0;
my @triples[$limit/2];
(3 .. $limit/2).race.map: -> $c {
   for 1 .. $c -> $a {
       my $b = ($c * $c - $a * $a).sqrt;
       last if $c + $a + $b > $limit;
       last if $a > $b;
       @triples[$i⚛++] = ([gcd] $c, $a, $b) > 1 ?? 0 !! 1 if $b == $b.Int;
   }
}

say my $result = "There are {+@triples.grep:{$_ !eqv Any}} Pythagorean Triples with a perimeter <= $limit,"
 ~"\nof which {[+] @triples.grep: so *} are primitive.";
