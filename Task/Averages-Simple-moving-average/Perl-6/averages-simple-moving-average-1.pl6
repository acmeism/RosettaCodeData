sub sma-generator (Int $P where * > 0) {
    sub ($x) {
        state @a = 0 xx $P;
        @a.push($x).shift;
        @a.sum / $P;
    }
}
