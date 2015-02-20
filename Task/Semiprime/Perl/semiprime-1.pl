use ntheory "factor";
print join(" ", grep { scalar factor($_) == 2 } 1..100),"\n";
print join(" ", grep { scalar factor($_) == 2 } 1675..1681),"\n";
print join(" ", grep { scalar factor($_) == 2 } (2,4,99,100,1679,5040,32768,1234567,9876543,900660121)),"\n";
