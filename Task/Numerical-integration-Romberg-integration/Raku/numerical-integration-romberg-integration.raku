# 20250707 Raku programming solution

sub Romberg(&func, $lower, $upper, $steps, $acc = 1e-8, $degree = 4, $batch = 6, :$parallel = False) {
   my ($h0, $s0) = $upper - $lower, &func($lower) + &func($upper);
   my @prev-row  = my $rr = ($s0 * $h0 / 2);

   for 1..$steps Z (2, * × 2 ... *) -> ($i, $n) {
      my ($ro, $h, $s) = $rr, $h0 / $n, $s0 / 2;

      $parallel ?? ( $s += sum ( $lower X+ ($h, 2*$h ... ($n-1)*$h) ).race(
                           :$degree, :$batch).map(&func) )
                !! ( for 1..^$n -> $j { $s += &func($lower + $j * $h) } );

      my @curr-row = $s * $h;

      $rr = do for 1..$i Z (4, * × 4 ... *) -> ($k, $f) {
         @curr-row[$k] = ($f*@curr-row[$k-1] - @prev-row[$k-1]) / ($f - 1)
      }[*-1];
      abs($rr - $ro) < $acc ?? ( last ) !! @prev-row = @curr-row
   }
   return $rr
}

# Test cases
say Romberg(&sin,  0, 1, 5).fmt("%.8f");
say Romberg(&exp, -3, 3, 5).fmt("%.8f");

#`[[[[[[ again not suitable for ATO consumption

sub expensive($x) { # Expensive function
   my $sum = 0;
   for 1..10000 {
      my $y = $x * $_;
      $sum += sin($y) * cos($y) * exp(-$y / ($_ * $_)) / ($_**3);
   }
   return $sum + ($x**20) * log($x + 1)
}

# Benchmark parallel vs sequential for steps = 5
say "\nSteps = ", my $steps = 5;
# Sequential
my $start = now;
my $result = Romberg(&expensive, 0, 1, $steps, 1e-8, 4, 6, :!parallel);
say "Sequential, Result: $result.fmt('%.8f'), Time: {now - $start} seconds";
# Parallel
$start = now;
$result = Romberg(&expensive, 0, 1, $steps, 1e-8, 4, 6, :parallel);
say "  Parallel, Result: $result.fmt('%.8f'), Time: {now - $start} seconds";

#]]]]]]
