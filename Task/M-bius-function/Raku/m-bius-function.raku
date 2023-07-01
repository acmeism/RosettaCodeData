use Prime::Factor;

sub μ (Int \n) {
    return 0 if n %% (4|9|25|49|121);
    my @p = prime-factors(n);
    +@p == +@p.unique ?? +@p %% 2 ?? 1 !! -1 !! 0
}

my @möbius = lazy flat '', 1, (2..*).hyper.map: &μ;

# The Task
put "Möbius sequence - First 199 terms:\n",
    @möbius[^200]».fmt('%3s').batch(20).join: "\n";
