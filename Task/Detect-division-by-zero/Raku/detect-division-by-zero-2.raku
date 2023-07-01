multi div($a, $b) { return $a / $b }
multi div($a, $b where { $b == 0 }) { note 'Attempt to divide by zero.'; return Nil }

say div(10, 2);
say div(1, sin(0));
