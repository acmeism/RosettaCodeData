import std.regex, std.algorithm;

immutable int[string] w2s;

nothrow static this() {
    w2s = ["IX":  9, "C":  100, "D":  500, "CM": 900, "I":   1,
           "XC": 90, "M": 1000, "L":   50, "CD": 400, "XL": 40,
           "V":   5, "X":   10, "IV":   4];
}

int toArabic(in string s) /*pure nothrow*/ {
    auto ms = match(s, regex("CM|CD|XC|XL|IX|IV|[MDCLXVI]", "g"));
    return reduce!((a, m) => a + w2s[m.hit])(0, ms);
}

void main() {
    assert("MCMXC".toArabic == 1990);
    assert("MMVIII".toArabic == 2008);
    assert("MDCLXVI".toArabic == 1666);
}
