import std.regex, std.algorithm;

int toArabic(in string s) /*pure nothrow*/ {
    static immutable weights = [1000, 900, 500, 400, 100,
                                90, 50, 40, 10, 9, 5, 4, 1];
    static immutable symbols = ["M","CM","D","CD","C","XC",
                                "L","XL","X","IX","V","IV","I"];

    int arabic;
    foreach (m; s.matchAll("CM|CD|XC|XL|IX|IV|[MDCLXVI]".regex))
        arabic += weights[symbols.countUntil(m.hit)];
    return arabic;
}

void main() {
    assert("MCMXC".toArabic == 1990);
    assert("MMVIII".toArabic == 2008);
    assert("MDCLXVI".toArabic == 1666);
}
