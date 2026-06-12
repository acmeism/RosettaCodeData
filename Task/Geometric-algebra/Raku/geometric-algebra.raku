class MultiVector is Mix {
  subset Vector of ::?CLASS is export where *.grades.all == 1;

  method narrow { self.keys.any > 0 ?? self !!  (self{0} // 0) }
  method grades { self.keys.map: *.base(2).comb.sum }

  multi method new(Real $x) returns ::?CLASS { self.new-from-pairs: 0 => $x }
  multi method new(Str $ where /^^e(\d+)$$/) { self.new-from-pairs: (1 +< (2*$0)) => 1 }

  our @e is export = map { ::?CLASS.new: "e$_" }, ^Inf;

  my sub order(UInt:D $i is copy, UInt:D $j) {
    (state %){$i}{$j} //= do {
      my $n = 0;
      repeat {
	$i +>= 1;
	$n += [+] ($i +& $j).polymod(2 xx *);
      } until $i == 0;
      $n +& 1 ?? -1 !! 1;
    }
  }

  sub infix:<·>(Vector $x, Vector $y) returns Real is export { (($x*$y + $y*$x)/2){0} }

  multi infix:<+>(::?CLASS $A, ::?CLASS $B) returns ::?CLASS is export {
    return ::?CLASS.new-from-pairs: |$A.pairs, |$B.pairs;
  }
  multi infix:<+>(Real $s, ::?CLASS $B) returns ::?CLASS is export {
    samewith $B.new($s), $B
  }
  multi infix:<+>(::?CLASS $A, Real $s) returns ::?CLASS is export {
    samewith $s, $A
  }

  multi infix:<*>(::?CLASS $,  0) is export { 0  }
  multi infix:<*>(::?CLASS $A, 1) returns ::?CLASS is export { $A }
  multi infix:<*>(::?CLASS $A, Real $s) returns ::?CLASS is export {
    ::?CLASS.new-from-pairs: $A.pairs.map({Pair.new: .key, $s*.value})
  }
  multi infix:<*>(::?CLASS $A, ::?CLASS $B) returns ::?CLASS is export {
    ::?CLASS.new-from-pairs: gather
      for $A.pairs -> $a {
	for $B.pairs -> $b {
	  take ($a.key +^ $b.key) => [*]
	    $a.value, $b.value,
	    order($a.key, $b.key),
	    |grep +*, (
		|(1, -1) xx * Z*
		($a.key +& $b.key).polymod(2 xx *)
	    )
	}
      }
  }
  multi infix:<**>(::?CLASS $ , 0) returns ::?CLASS is export { ::?CLASS.new: (0 => 1).Mix }
  multi infix:<**>(::?CLASS $A, 1) returns ::?CLASS is export { $A }
  multi infix:<**>(::?CLASS $A, 2) returns ::?CLASS is export { $A * $A }
  multi infix:<**>(::?CLASS $A, UInt $n where $n %% 2) returns ::?CLASS is export { ($A ** ($n div 2)) ** 2 }
  multi infix:<**>(::?CLASS $A, UInt $n) returns ::?CLASS is export { $A * ($A ** ($n div 2)) ** 2 }

  multi infix:<*>(Real $s, ::?CLASS $A) returns ::?CLASS is export { $A * $s }
  multi infix:</>(::?CLASS $A, Real $s) returns ::?CLASS is export { $A * (1/$s) }
  multi prefix:<->(::?CLASS $A) returns ::?CLASS is export { return -1 * $A }
  multi infix:<->(::?CLASS $A, ::?CLASS $B) returns ::?CLASS is export { $A + -$B }
  multi infix:<->(::?CLASS $A, Real $s) returns ::?CLASS is export { $A + -$s }
  multi infix:<->(Real $s, ::?CLASS $A) returns ::?CLASS is export { $s + -$A }

  multi infix:<==>(::?CLASS $A, 0) returns Bool is export { $A.elems == 0 }
  multi infix:<==>(::?CLASS $A, ::?CLASS $B) returns Bool is export { samewith $A - $B, 0 }
  multi infix:<==>(Real $x, ::?CLASS $A) returns Bool is export { samewith $A, $x }
  multi infix:<==>(::?CLASS $A, Real $x) returns Bool is export { samewith $A, $A.new($x); }

  sub random is export {
      [+] map {
	  ::?CLASS.new-from-pairs: $_ => rand.round(.01)
      }, ^32;
  }
}

#########################################
##  Test code to verify the solution:  ##
#########################################

import MultiVector;
use Test;

constant N = 10;
plan 5;

subtest "Orthonormality", {
  for ^N X ^N -> ($i, $j) {
    my $s = $i == $j ?? 1 !! 0;
    ok @e[$i]·@e[$j] == $s, "e$i·e$j = $s";
  }
}

my ($a, $b, $c) = random() xx 3;

ok ($a*$b)*$c == $a*($b*$c), 'associativity';
ok $a*($b + $c) == $a*$b + $a*$c, 'left distributivity';
ok ($a + $b)*$c == $a*$c + $b*$c, 'right distributivity';
my @coeff = (.5 - rand) xx 5;
my $v = [+] @coeff Z* @e[^5];
ok ($v**2).narrow ~~ Real, 'contraction';
