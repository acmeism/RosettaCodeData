# 20250620 Raku programming solution

# Convert integer to binary string of length vars
sub b2s(Int $i is copy, Int $vars) returns Str {
   return ( "0" x $vars ~ $i.base(2) ).substr( * - $vars )
}

# Count number of '1's in the string
sub bit-count(Str $s) returns Int { return $s.comb.grep('1').elems }

# Merge two implicants if they differ in exactly one bit; else return ''
sub merge(Str $i, Str $j) returns Str {
   my $diff-count = 0;

   return [~] gather for $i.comb Z $j.comb -> ($a, $b) {
      take do if 'X' eq $a | $b {
         $a ne $b ?? (return '') !! $a
      } elsif $a ne $b {
         ++$diff-count > 1 ?? (return '') !! 'X'
      } else {
         $a
      }
   }
}

# Check if prime covers one (prime can have 'X' as don't care)
sub is-cover(Str $prime, Str $one) returns Bool {
   for ^( min($prime.chars, $one.chars) ) -> $i {
      my ($p, $o) = ($prime, $one)>>.substr($i, 1);
      return False if ('X', $o).none eq $p;
   }
   return True;
}

# Check if all minterms in ones are covered by primes
sub is-full-cover(Set $all-primes, Set $ones) returns Bool {
   for $ones.keys -> $one {
      return False unless $all-primes.keys.grep({ is-cover($_, $one) }) > 0
   }
   return True;
}

# Compute prime implicants from cubes
sub compute-primes(Set $cubes, Int $vars) returns Set {
   my @sigma = set() xx ($vars + 1);
   my $sigma-count = 0;

   for ^($vars + 1) -> $j { # Group cubes by bit count
      for $cubes.keys -> $cube { @sigma[$j] ∪= $cube if bit-count($cube) == $j }
      if @sigma[$j].elems > 0 { $sigma-count = $j + 1 }
   }

   my $primes = set();

   while $sigma-count > 0 {
      my @nsigma = set() xx ($sigma-count - 1);
      my $redundant = set();

      for ^($sigma-count - 1) -> $i { # Try to merge adjacent groups
         my ($c1, $c2, $nc) = @sigma[$i], @sigma[$i + 1], set();

         for $c1.keys X $c2.keys -> ($a, $b) {
            if '' ne my $m = merge($a, $b) {
               $nc ∪= $m;
               $redundant ∪= $a;
               $redundant ∪= $b;
            }
         }
         @nsigma[$i] = $nc;
      }

      for ^$sigma-count -> $i { # Add non-redundant terms to primes
         for @sigma[$i].keys { $primes ∪= $_ unless $_ ∈ $redundant }
      }

      if ( $sigma-count = @nsigma.elems ) > 0 {
         @sigma[^$sigma-count] = @nsigma[^$sigma-count]
      }
   }
   return $primes;
}

# Return active primes selected by cubesel bitmask
sub active-primes(Int $cubesel, @primes) returns Set {
   my $s = b2s($cubesel, @primes.elems);

   return @primes[ ^@primes.elems .grep: { $s.substr($_,1) eq '1' } ].Set
}

# Find minimal cover of ones by primes using unate cover approach
sub unate-cover(Set $primes-set, Set $ones) returns Set {
   my @primes = $primes-set.keys.sort;
   my $min-count = Inf;
   my $min-sel = -1;
   my $total = 2 ** @primes.elems;

   for ^$total -> $cubesel {
      my $active = active-primes($cubesel, @primes);
      if is-full-cover($active, $ones) {
         if ( my $count = $active.elems ) < $min-count {
            ($min-count, $min-sel) = $count, $cubesel
         }
      }
   }
   return $min-sel == -1 ?? Set.new !! active-primes($min-sel, @primes);
}

# Main Quine-McCluskey function
sub qm(@ones, @zeros, @dc) returns Set {
    return Set.new if (@ones, @zeros, @dc)>>.elems.all == 0;

    my $max-val = (@ones, @zeros, @dc).flat.max // 0;
    my $num-vars = $max-val == 0 ?? 1 !! (log($max-val)/2.log).ceiling;
    my $ones-set = @ones.map({ b2s($_, $num-vars) }).Set;
    my $zeros-set = @zeros.map({ b2s($_, $num-vars) }).Set;
    my $dc-set = @dc.map({ b2s($_, $num-vars) }).Set;
    my $cubes = $ones-set ∪ $dc-set;
    my $primes = compute-primes($cubes, $num-vars);

    return unate-cover($primes, $ones-set);
}

say qm( [1, 2, 5], [], [0, 7] ).keys.sort.Str;
