constant factory = 0..* Z=> (0, 0, map { +factors($_) }, 2..*);

sub almost($n) { map *.key, grep *.value == $n, factory }

say almost($_)[^10] for 1..5;
