# 20231020 Raku programming solution

class Point { has Rat ($.x, $.y) }

sub add(@p1, @p2) { return @p1 <<+>> @p2 } # Add two polynomials.

sub multiply(@p1, @p2) { # Multiply two polynomials.
   my @prod;
   for ^+@p1 X ^+@p2 -> ($i, $j) { @prod[$i + $j] += @p1[$i] * @p2[$j] }
   return @prod;
}

# Multiply a polynomial by a scalar.
sub scalarMultiply(@poly, $x) { return @poly.map: * × $x }

# Divide a polynomial by a scalar.
sub scalarDivide(@poly, $x) { return scalarMultiply(@poly, 1/$x) }

# rosettacode.org/wiki/Horner%27s_rule_for_polynomial_evaluation#Raku
sub evalPoly(@coefs, $x) { return ([o] map { $_ + $x × * }, @coefs.reverse)(0) }

sub lagrange(@pts) {
   my ($c, @polys) = @pts.elems;
   for ^$c -> $i {
      my @poly = 1;
      for ^$c -> $j {
         next if $i == $j;
         @poly = multiply @poly, [ -@pts[$j].x, 1 ]
      }
      @polys[$i] = scalarDivide @poly, evalPoly(@poly.reverse, @pts[$i].x)
   }
   my @sum = 0;
   for ^$c -> $i { @sum = add @sum, scalarMultiply @polys[$i], @pts[$i].y }
   return @sum;
}


my @pts = map { Point.new: x=>.[0].Rat,y=>.[1].Rat }, [<1 1>,<2 4>,<3 1>,<4 5>];

say [~] lagrange(@pts).kv.rotor(2).reverse.map: -> ($expo, $coef) {
   "{ '+' if $coef ≥ 0 }$coef.nude.join('/') " ~ do given $expo {
      when 0  { " " }
      when 1  { "𝑥 " }
      default { "𝑥^$_ " }
   }
}
