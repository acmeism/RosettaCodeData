say Σ $_ for <1 1234 1020304 fe f0e DEADBEEF>;

sub Σ { [+] $^n.comb.map: { :36($_) } }
