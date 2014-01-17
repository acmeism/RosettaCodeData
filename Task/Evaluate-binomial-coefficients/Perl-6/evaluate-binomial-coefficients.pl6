sub infix:<choose>($n, $k) { ([*] $n-$k+1 .. $n) / [*] 2 .. $k }

say 5 choose 3;
