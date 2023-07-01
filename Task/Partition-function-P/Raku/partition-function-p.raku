my @P = 1, { p(++$) } … *;
my @i = lazy [\+] flat 1, ( 1..* Z (1..*).map: * × 2 + 1 );
sub p ($n) { sum @P[$n X- @i] Z× (flat (1, 1, -1, -1) xx *) }

put @P[^26];
put @P[6666];
