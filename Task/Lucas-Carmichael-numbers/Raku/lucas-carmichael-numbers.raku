# 20231224 Raku programming solution

sub primorial($n) { [*] ((2..*).grep: *.is-prime)[^$n] }
sub divceil($x, $y) { ($x %% $y ?? 0 !! 1) + $x div $y } # ceil(x/y)

sub LC_in_range ($A is copy, $B, $k) {

   my ($max_p, @LC) = Int(sqrt($B + 1) - 1);
   $A = max(primorial($k + 1) +> 1, $A);

   sub SUB($m, $L, $lo is copy, $k) {

      if $k == 1 {

         my $hi = min($B div $m, $max_p);
         $lo = max($lo, divceil($A, $m));

         my $t = $L - expmod($m, -1, $L);
         $t += $L while $t < $lo;
         return if $t > $hi;

         for $t, $t+$L ... $hi -> $p {
            if $p.is-prime {
               my $n = $m * $p;
               @LC.push($n) if ($n + 1) %% ($p + 1);
            }
         }
         return;
      }

      for $lo .. Int(($B div $m)**(1/$k)) -> $p {
         if $p.is-prime and ($m gcd ($p + 1)) == 1 {
            SUB($m * $p, ($L lcm ($p + 1)), $p + 1, $k - 1)
         }
      }
   };

   SUB(1, 1, 3, $k);

   return @LC.sort;
}

sub LC_with_n_primes ($n) {
   return if $n < 3;

   my $y = 2 * ( my $x = primorial($n + 1) +> 1);

   loop {
      my @LC = LC_in_range($x, $y, $n);
      return @LC[0] if @LC.Bool;
      $x = $y + 1;
      $y = 2 * $x;
   }
}

sub LC_count ($A, $B) {
   my $count = 0;
   for 3 .. Inf -> $k {
      last if primorial($k + 1) / 2 > $B;
      $count += LC_in_range($A, $B, $k).elems
   }
   return $count;
}

say "Least Lucas-Carmichael number with n prime factors:";

for 3 .. 12 -> $n { printf("%2d: %d\n", $n, LC_with_n_primes($n)) }

say "\nNumber of Lucas-Carmichael numbers less than 10^n:";

my $acc = 0;
for 1 .. 10 -> $n {
   my $c = LC_count(10**($n - 1), 10**$n);
   printf("%2d: %s\n", $n, $acc + $c);
   $acc += $c
}
