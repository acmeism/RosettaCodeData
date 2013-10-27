sub factors (Int $n) {
    sort uniq
    map { $^x, $n div $^x },
    grep { $n %% $^x },
    1 .. sqrt $n;
}
