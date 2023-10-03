sub infix:<√>($n, $A) {
    .tail given $A / $n, { (($n-1) * $_+ $A / ($_** ($n-1))) / $n } ... * ≅ *;
}

use Test;
plan 9;
is-approx ($_√pi)**$_, pi for 2 .. 10;
