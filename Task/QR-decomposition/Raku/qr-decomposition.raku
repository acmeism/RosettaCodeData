# sub householder translated from https://codereview.stackexchange.com/questions/120978/householder-transformation

use v6;

sub identity(Int:D $m --> Array of Array) {
   my Array @M;

   for 0 ..^ $m -> $i {
      @M.push: [0 xx $m];
      @M[$i; $i] = 1;
   }

   @M;
}

multi multiply(Array:D @A, @b where Array:D --> Array) {
   my @c;

   for ^@A X ^@b -> ($i, $j) {
      @c[$i] += @A[$i; $j] * @b[$j];
   }

   @c;
}

multi multiply(Array:D @A, Array:D @B --> Array of Array) {
   my Array @C;

   for ^@A X ^@B[0] -> ($i, $j) {
      @C[$i; $j] += @A[$i; $_] * @B[$_; $j] for ^@B;
   }

   @C;
}

sub transpose(Array:D @M --> Array of Array) {
   my ($rows, $cols) = (@M.elems, @M[0].elems);

   my Array @T;

   for ^$cols X ^$rows -> ($j, $i) {
      @T[$j; $i] = @M[$i; $j];
   }

   @T;
}

####################################################
# NOTE: @A gets overwritten and becomes @R, only need
# to return @Q.
####################################################
sub householder(Array:D @A --> Array) {
   my Int ($m, $n) = (@A.elems, @A[0].elems);
   my @v = 0 xx $m;
   my Array @Q = identity($m);

   for 0 ..^ $n -> $k {
      my Real $sum = 0;
      my Real $A0 = @A[$k; $k];
      my Int $sign = $A0 < 0 ?? -1 !! 1;

      for $k ..^ $m -> $i {
         $sum += @A[$i; $k] * @A[$i; $k];
      }

      my Real $sqr_sum = $sign * sqrt($sum);
      my Real $tmp = sqrt(2 * ($sum + $A0 * $sqr_sum));
      @v[$k] = ($sqr_sum  + $A0) / $tmp;

      for ($k + 1) ..^ $m -> $i {
         @v[$i] = @A[$i; $k] / $tmp;
      }

      for 0 ..^ $n -> $j {
         $sum = 0;

         for $k ..^ $m -> $i {
            $sum += @v[$i] * @A[$i; $j];
         }

         for $k ..^ $m -> $i {
            @A[$i; $j] -= 2 * @v[$i] * $sum;
         }
      }

      for 0 ..^ $m -> $j {
         $sum = 0;

         for $k ..^ $m -> $i {
            $sum += @v[$i] * @Q[$i; $j];
         }

         for $k ..^ $m -> $i {
            @Q[$i; $j] -= 2 * @v[$i] * $sum;
         }
      }
   }

   @Q
}

sub dotp(@a where Array:D, @b where Array:D --> Real) {
   [+] @a >>*<< @b;
}

sub upper-solve(Array:D @U, @b where Array:D, Int:D $n --> Array) {
   my @y = 0 xx $n;

   @y[$n - 1] = @b[$n - 1] / @U[$n - 1; $n - 1];

   for reverse ^($n - 1) -> $i {
      @y[$i] = (@b[$i] - (dotp(@U[$i], @y))) / @U[$i; $i];
   }

   @y;
}

sub polyfit(@x where Array:D, @y where Array:D, Int:D $n) {
   my Int $m = @x.elems;
   my Array @V;

   # Vandermonde matrix
   for ^$m X (0 .. $n) -> ($i, $j) {
      @V[$i; $j] = @x[$i] ** $j
   }

   # least squares
   my $Q = householder(@V);
   my @b = multiply($Q, @y);

   return upper-solve(@V, @b, $n + 1);
}

sub print-mat(Array:D @M, Str:D $name) {
   my Int ($m, $n) = (@M.elems, @M[0].elems);
   print "\n$name:\n";

   for 0 ..^ $m -> $i {
      for 0 ..^ $n -> $j {
         print @M[$i; $j].fmt("%12.6f ");
      }

      print "\n";
   }
}

sub MAIN() {
   ############
   # 1st part #
   ############
   my Array @A = (
      [12, -51,   4],
      [ 6, 167, -68],
      [-4,  24, -41],
      [-1,   1,   0],
      [ 2,   0,   3]
   );

   print-mat(@A, 'A');
   my $Q = householder(@A);
   $Q = transpose($Q);
   print-mat($Q, 'Q');
   # after householder, @A is now @R
   print-mat(@A, 'R');
   print-mat(multiply($Q, @A), 'check Q x R = A');

   ############
   # 2nd part #
   ############
   my @x = [^11];
   my @y = [1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321];

   my @coef = polyfit(@x, @y, 2);

   say
      "\npolyfit:\n",
      <constant X X^2>.fmt("%12s"),
      "\n",
      @coef.fmt("%12.6f");
}
