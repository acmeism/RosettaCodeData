sub factors (Int $n) {
    sort +*, keys hash
        map { $^x => 1, $n div $^x => 1 },
        grep { $n %% $^x },
        1 .. ceiling sqrt $n;
}
