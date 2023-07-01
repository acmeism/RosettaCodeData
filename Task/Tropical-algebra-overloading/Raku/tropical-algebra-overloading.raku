sub infix:<⊕> (Real $a, Real $b) is equiv(&[+]) { $a max $b }
sub infix:<⊗> (Real $a, Real $b) is equiv(&[×]) { $a + $b }
sub infix:<↑> (Real $a,  Int $b where * ≥ 0) is equiv(&[**]) { [⊗] $a xx $b }

use Test;

is-deeply(      2 ⊗ -2,        0, '2 ⊗ -2 == 0' );
is-deeply( -0.001 ⊕ -Inf, -0.001, '-0.001 ⊕ -Inf == -0.001' );
is-deeply(      0 ⊗ -Inf,   -Inf, '0 ⊗ -Inf == -Inf' );
is-deeply(    1.5 ⊕ -1,      1.5, '1.5 ⊕ -1 == 1.5' );
is-deeply(   -0.5 ⊗ 0,      -0.5, '-0.5 ⊗ 0 == -0.5' );
is-deeply(      5 ↑ 7,        35, '5 ↑ 7 == 35' );
is-deeply( 5 ⊗ (8 ⊕ 7),  5 ⊗ 8 ⊕ 5 ⊗ 7, '5 ⊗ (8 ⊕ 7) == 5 ⊗ 8 ⊕ 5 ⊗ 7');
is-deeply( 5 ↑ 7 ⊕ 6 ↑ 6,     36, '5 ↑ 7 ⊕ 6 ↑ 6 == 36');
