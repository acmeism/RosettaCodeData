# Reference:
# https://github.com/pierre-vigier/Perl6-Math-Matrix
# Mastering Algorithms with Perl
# By Jarkko Hietaniemi, John Macdonald, Jon Orwant
# Publisher: O'Reilly Media, ISBN-10: 1565923987
# https://resources.oreilly.com/examples/9781565923980/blob/master/ch16/solve

use v6;

sub solve_funcs ($funcs, @guesses, $iterations, $epsilon) {
   my ($error_value, @values, @delta, @jacobian); my \ε = $epsilon;
   for 1 .. $iterations {
      for ^+$funcs { @values[$^i] = $funcs[$^i](|@guesses); }
      $error_value = 0;
      for ^+$funcs { $error_value += @values[$^i].abs }
      return @guesses if $error_value ≤ ε;
      for ^+$funcs { @delta[$^i] = -@values[$^i] }
      @jacobian = jacobian $funcs, @guesses, ε;
      @delta = solve_matrix @jacobian, @delta;
      loop (my $j = 0, $error_value = 0; $j < +$funcs; $j++) {
         $error_value += @delta[$j].abs ;
         @guesses[$j] += @delta[$j];
      }
      return @guesses if $error_value ≤ ε;
   }
   return @guesses;
}

sub jacobian ($funcs is copy, @points is copy, $epsilon is copy) {
   my ($Δ, @P, @M, @plusΔ, @minusΔ);
   my Array @jacobian; my \ε = $epsilon;
   for ^+@points -> $i {
      @plusΔ = @minusΔ = @points;
      $Δ = (ε * @points[$i].abs) || ε;
      @plusΔ[$i] = @points[$i] + $Δ;
      @minusΔ[$i] = @points[$i] - $Δ;
      for ^+$funcs { @P[$^k] = $funcs[$^k](|@plusΔ); }
      for ^+$funcs { @M[$^k] = $funcs[$^k](|@minusΔ); }
      for ^+$funcs -> $j {
         @jacobian[$j][$i] = (@P[$j] - @M[$j]) / (2 * $Δ);
      }
   }
   return @jacobian;
}

sub solve_matrix (@matrix_array is copy, @delta is copy) {
   # https://github.com/pierre-vigier/Perl6-Math-Matrix/issues/56
   { use Math::Matrix;
      my $matrix = Math::Matrix.new(@matrix_array);
      my $vector = Math::Matrix.new(@delta.map({.list}));
      die "Matrix is not invertible" unless $matrix.is-invertible;
      my @result = ( $matrix.inverted dot $vector ).transposed;
      return @result.split(" ");
   }
}

my $funcs = [
   { 9*$^x² + 36*$^y² + 4*$^z² - 36 }
   { $^x² - 2*$^y² - 20*$^z }
   { $^x² - $^y² + $^z² }
];

my @guesses = (1,1,0);

my @solution = solve_funcs $funcs, @guesses, 20, 1e-8;

say "Solution: ", @solution;
