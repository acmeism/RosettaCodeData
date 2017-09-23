use ntheory "factor";
print join(" ", grep { scalar factor($_) == 2 } 1..100),"\n";
