sub sma-generator (Int $P where * > 0) {
    sub ($x) {
        state @a = 0 xx $P;
        @a.push($x).shift;
        @a.sum / $P;
    }
}

# Usage:
my &sma = sma-generator 3;

for 1, 2, 3, 2, 7 {
    printf "append $_ --> sma = %.2f  (with period 3)\n", sma $_;
}
