# 20250704 Raku programming solution

sub is_antisymmetric(@a) {
   my $n = @a.elems;
   for ^$n -> $i {
      return False if @a[$i][$i] != 0;  # Diagonal elements must be zero
      for $i+1..^$n -> $j { return False if @a[$i][$j] != -@a[$j][$i] }
   }
   return True;
}

sub factorial(Int $n --> Int) {
   state @cache = 1;
   @cache[$_] //= @cache[$_ - 1] * $_ for @cache.elems .. $n;
   return @cache[$n]
}

sub spermutations(Int $n, Bool :$pfaffian = True) {
   sub permutation-sign(@p) {
      my $inversions = 0;
      for ^@p -> $i { for $i+1..^@p -> $j { $inversions++ if @p[$i] > @p[$j] } }
      return $inversions %% 2 ?? 1 !! -1
   }
   return lazy (0..$n).permutations.map: -> @p {
      [@p, $pfaffian ?? permutation-sign(@p) !! 1]
   }
}

sub faffian(@a, Bool $pfaffian) {
   my $size = @a.elems;
   unless $size %% 2 {
      say "Matrix size must be even for {$pfaffian ?? "P" !! "H"}faffian.";
      return Nil;
   }
   unless is_antisymmetric(@a) {
      say "The {$pfaffian ?? "P" !! "H"}faffian does not support non-antisymmetric matrices yet.\n";
      return Nil;
   }

   my $n = $size div 2;
   my $normalization = 1 / (2 ** $n * factorial($n));
   my $sum = 0;
   my @perms = spermutations(2 * $n - 1, :$pfaffian);

   for @perms -> @ss {
      my @sigma = @ss[0];
      my $sign = $pfaffian ?? @ss[1] !! 1;
      my $prod = 1;
      for ^$n -> $i { $prod *= @a[@sigma[2 * $i]][@sigma[2 * $i + 1]] }
      $sum += $sign * $prod;
   }
   return $sum * $normalization;
}

sub faffian_recursive(@a, Bool :$pfaffian = True) {
   my $n = @a.elems;

   unless $n %% 2 {
      say "Matrix size must be even for {$pfaffian ?? 'Pfaffian' !! 'Hfaffian'}.";
      return Nil;
   }

   unless is_antisymmetric(@a) {
      say "The {$pfaffian ?? 'Pfaffian' !! 'Hfaffian'} does not support non-antisymmetric matrices yet.\n";
      return Nil;
   }

   return 0 unless $pfaffian; # Antisymmetric Hfaffian is always 0

   return 1 if $n == 0;  # Recursive Pfaffian computation
   return @a[0][1] if $n == 2;

   my $result = 0;
   for 1..^$n -> $j {
      next if @a[0;$j]  == 0;

      # Build submatrix excluding row/col 0 and $j
      my @rows = (1..^$n).grep({ $_ != $j });
      my @submatrix = @rows.map: -> $i {
         my @cols = (1..^$n).grep({ $_ != $j });
         [ @a[$i][@cols] ]
      };

      my $sign = ($j + 1) %% 2 ?? -1 !! 1;
      $result += $sign * @a[0][$j] * faffian_recursive(@submatrix, :pfaffian);
   }
   return $result;
}

# Example matrices
my @matrices = (
   [[0, 1], [-1, 0]], # Tiny matrix (2 x 2)

   [ [0, 1, -1, 2],   # Small matrix (4 x 4)
     [-1, 0, 3, -4],
     [1, -3, 0, 5],
     [-2, 4, -5, 0] ],

   [ [1, 2, 3, 4, 5, 6], # Symmetric matrix (6 x 6)
     [2, 7, 8, 9, 10, 11],
     [3, 8, 12, 13, 14, 15],
     [4, 9, 13, 16, 17, 18],
     [5, 10, 14, 17, 19, 20],
     [6, 11, 15, 18, 20, 21] ],

   [ [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], # Larger matrix (10 x 10)
     [-1, 0, 8, 7, 6, 5, 4, 3, 2, 1],
     [-2, -8, 0, 1, 2, 3, 4, 5, 6, 7],
     [-3, -7, -1, 0, 6, 5, 4, 3, 2, 1],
     [-4, -6, -2, -6, 0, 1, 2, 3, 4, 5],
     [-5, -5, -3, -5, -1, 0, 4, 3, 2, 1],
     [-6, -4, -4, -4, -2, -4, 0, 1, 2, 3],
     [-7, -3, -5, -3, -3, -3, -1, 0, 2, 1],
     [-8, -2, -6, -2, -4, -2, -2, -2, 0, 1],
     [-9, -1, -7, -1, -5, -1, -3, -1, -1, 0] ]
);

for @matrices -> @m {
   for @m -> @row { say "| ", @row.map({ sprintf("%3d", $_) }).join(" "), " |" }
   say "";

   my $pf = faffian_recursive(@m, :pfaffian);
   my $hf = faffian_recursive(@m, :!pfaffian);
   printf "Pfaffian: %.1f\n", $pf if $pf.defined;
   printf "Hfaffian: %.1f\n\n", $hf if $hf.defined;
}
