# 20250703 Raku programming solution

sub Tanh-Sinh(&func, $lower, $upper, $steps, $acc = 1e-8, $degree = 4, $batch = 50, :$parallel = False) {
   my ($h, $rr, $h0, $h1) = 0.1, 0, ($upper-$lower)/2, ($lower+$upper)/2;

   for 1..$steps { # Refinement loop for increasing quadrature resolution
      my ($ro, $ss, $n) = $rr, 0, 2**$_ - 1;

      if $parallel { # Parallelized quadrature point loop
         my @results = (-$n..$n).race(batch => $batch, degree => $degree).map: -> $i {
            my ($sh, $ch) = { $_.sinh, $_.cosh }($i*$h);
            my $th = tanh($sh * pi / 2);
            my $dx = ($ch * pi / 2) / (cosh($sh * pi / 2) ** 2);
            &func($h1 + $h0 * $th) * $h * $dx
         }
         $ss = @results.sum
      } else { # Sequential quadrature point loop
         for -$n..$n -> $i {
            my ($sh, $ch) = { $_.sinh, $_.cosh }($i*$h);
            my $th = tanh($sh * pi / 2);
            my $dx = ($ch * pi / 2) / (cosh($sh * pi / 2) ** 2);
            $ss += &func($h1 + $h0 * $th) * $h * $dx
         }
      }
      $rr = $h0 * $ss;
      last if abs($rr - $ro) < $acc;
   }
   return $rr;
}

say Tanh-Sinh(&sin,  0, 1, 5).fmt("%.8f");
say Tanh-Sinh(&exp, -3, 3, 5).fmt("%.8f");

#`[[[[[[ Not suitable for ATO :-D

sub expensive($x) { # Expensive function
   my $sum = 0;
   for 1..5000 {
      my $y = $x * $_;
      $sum += sin($y) * cos($y) * exp(-$y / ($_ * $_)) / ($_**3);
   }
   return $sum + ($x**20) * log($x + 1)
}

# Benchmark parallel vs sequential for steps = 5
say "\nSteps = ", my $steps = 5;

# Sequential
my $start = now;
my $result = Tanh-Sinh(&expensive, 0, 1, $steps, 1e-8, 4, 5, :!parallel);
say "Sequential, Result: $result.fmt('%.8f'), Time: {now - $start} seconds";

# Parallel
$start = now;
$result = Tanh-Sinh(&expensive, 0, 1, $steps, 1e-8, 4, 5, :parallel);
say "  Parallel, Result: $result.fmt('%.8f'), Time: {now - $start} seconds";

# ]]]]]]
