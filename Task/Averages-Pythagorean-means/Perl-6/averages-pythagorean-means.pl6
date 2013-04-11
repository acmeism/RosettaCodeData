sub A(@x) { ([+] @x) / @x.elems }
sub G(@x) { ([*] @x) ** (1 / @x.elems) }
sub H(@x) { @x.elems / [+] @x.map: 1/* }

say "A(1,...,10) = ", A(1..10);
say "G(1,...,10) = ", G(1..10);
say "H(1,...,10) = ", H(1..10);
