# 20240228 Raku programming solution

use Prime::Factor;

sub phi(Int $p, Int $r) { return $p**($r - 1) * ($p - 1) }

sub CarmichaelLambda(Int $n) {

   state %cache = 1 => 1, 2 => 1, 4 => 2;

   sub CarmichaelHelper(Int $p, Int $r) {
      my Int $n = $p ** $r;
      return %cache{$n} if %cache{$n}:exists;
      return %cache{$n} = $p > 2 ?? phi($p, $r) !! phi($p, $r - 1)
   }

   if $n < 1 { die "'n' must be a positive integer." }
   return %cache{$n} if %cache{$n}:exists;
   if ( my %pps = prime-factors($n).Bag ).elems == 1 {
      my ($p, $r) = %pps.kv>>.Int;
      return %cache{$n} = $p > 2 ?? phi($p, $r) !! phi($p, $r - 1)
   }
   return [lcm] %pps.kv.map: -> $k, $v { CarmichaelHelper($k.Int, $v) }
}

sub iteratedToOne($i is copy) {
   my $k = 0;
   while $i > 1 { $i = CarmichaelLambda($i) andthen $k++ }
   return $k
}

say " n   λ   k";
say "----------";
for 1..25 -> $n {
   printf "%2d  %2d  %2d\n", $n, CarmichaelLambda($n), iteratedToOne($n)
}

say "\nIterations to 1       i     lambda(i)";
say "=====================================";
say "   0                  1            1";

my ($maxI, $maxN) = 5e6, 10; # for N=15, takes around 47 minutes with an i5-10500T
my @found = True, |( False xx $maxN );
for 1 .. $maxI -> $i {
   unless @found[ my $n = iteratedToOne($i) ] {
      printf "%4d %18d %12d\n", $n, $i, CarmichaelLambda($i);
      @found[$n] = True andthen ( last if $n == $maxN )
   }
}
