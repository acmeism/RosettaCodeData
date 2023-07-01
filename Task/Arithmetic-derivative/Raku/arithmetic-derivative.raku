use Prime::Factor;

multi D (0) { 0 }
multi D (1) { 0 }
multi D ($n where &is-prime) { 1 }
multi D ($n where * < 0 ) { -D -$n }
multi D ($n) { sum $n.&prime-factors.Bag.map: { $n × .value / .key } }


put (-99 .. 100).map(&D).batch(10)».fmt("%4d").join: "\n";

put '';

put join "\n", (1..20).map: { sprintf "D(10**%-2d) / 7 == %d", $_, D(10**$_) / 7 }
