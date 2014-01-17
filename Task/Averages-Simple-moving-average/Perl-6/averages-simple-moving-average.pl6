sub sma(Int $period where * > 0) returns Sub {
    sub ($x) {
        state @a = 0 xx $period;
        @a.push($x);
        @a.shift;
        $period R/ [+] @a;
    }
}
