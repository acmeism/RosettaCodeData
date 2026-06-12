# 20200807 Raku programming solution (Incomplete)

sub check ($type, @testee) {
   @testee.map: { say "Is\t$_\t∈ ", $type.^name, "\t: ", $_ ~~ $type}
}

# 1.1 natural numbers

subset ℕ of Any where ( $_ ≥ 0 and $_.narrow ~~ Int ); # add constraints to Any
# alternative : subset ℕ of Int where * ≥ 0;

check ℕ, < 0 1 -1 3.3 >;

# 1.2 even natural numbers

subset EvenNatural of ℕ where * %% 2;

check EvenNatural, < 33 66 >;

# 1.3 odd natural numbers

subset OddNatural of ℕ where ( $_ ≠ $_ div 2 × 2 );
# alternative : subset OddNatural of ℕ where * !~~ Even;

check OddNatural, < 33 66 >;

# 2.1 Define the addition on natural numbers  (Translation from #Go)

sub infix:<⊞>(ℕ $a, ℕ $b --> ℕ) {
   return $a if $b == 0;
   return $a.succ ⊞ $b.pred;
}

check ℕ, [ 3 ⊞ 5 ];

# 3.1 Prove that the addition of any two even numbers is even
# 3.2 Prove that the addition is always associative
# 3.3 Prove that the addition is always commutative
# 3.4 Try to prove that the addition of any two even numbers is odd (it should be rejected)

# 4.1 Prove that the addition of any two even numbers cannot be odd
# 4.2 Try to prove that the addition of any two even numbers cannot be even (it should be rejected)
