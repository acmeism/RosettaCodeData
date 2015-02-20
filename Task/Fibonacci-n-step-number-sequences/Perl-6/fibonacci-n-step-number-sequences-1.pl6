sub fibo ($n) {
    constant @starters = 1,1,2,4 ... *;
    nacci @starters[^$n];
}

sub nacci (*@starter) {
    my &fun = EVAL join '+', '*' xx @starter;
    @starter, &fun ... *;
}

for 2..10 -> $n { say fibo($n)[^20] }
say nacci(2,1)[^20];
