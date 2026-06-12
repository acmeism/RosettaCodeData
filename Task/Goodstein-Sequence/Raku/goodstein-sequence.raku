# 20240219 Raku programming solution

sub bump($n is copy, $b) {
   loop ( my ($res, $i) = 0, 0; $n.Bool or return $res; $i++,$n div= $b) {
      if my $d = $n % $b { $res += $d * ($b+1) ** bump($i,$b) }
   }
}

sub goodstein($n, $maxterms = 10) {
   my @res = $n;
   while @res.elems < $maxterms && @res[*-1] != 0 {
      @res.push(bump(@res[*-1], (@res.elems + 1)) - 1)
   }
   return @res
}

say "Goodstein(n) sequence (first 10) for values of n from 0 through 7:";
for 0..7 -> $i { say "Goodstein of $i: ", goodstein($i) }

my $max = 16;
say "\nThe Nth term of Goodstein(N) sequence counting from 0, for values of N from 0 through $max :";
for 0..$max -> $i { say "Term $i of Goodstein($i): {goodstein($i, $i+1)[*-1]}" }
