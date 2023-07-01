auto jaro(in string s1, in string s2) {
    int s1_len = cast(int) s1.length;
    int s2_len = cast(int) s2.length;
    if (s1_len == 0 && s2_len == 0) return 1;

    import std.algorithm.comparison: min, max;
    auto match_distance = max(s1_len, s2_len) / 2 - 1;
    auto s1_matches = new bool[s1_len];
    auto s2_matches = new bool[s2_len];
    int matches = 0;
    for (auto i = 0; i < s1_len; i++) {
        auto start = max(0, i - match_distance);
        auto end = min(i + match_distance + 1, s2_len);
        for (auto j = start; j < end; j++)
            if (!s2_matches[j] && s1[i] == s2[j]) {
                s1_matches[i] = true;
                s2_matches[j] = true;
                matches++;
                break;
            }
    }
    if (matches == 0) return 0;

    auto t = 0.0;
    auto k = 0;
    for (auto i = 0; i < s1_len; i++)
        if (s1_matches[i]) {
            while (!s2_matches[k]) k++;
            if (s1[i] != s2[k++]) t += 0.5;
        }
    double m = matches;
    return (m / s1_len + m / s2_len + (m - t) / m) / 3.0;
}

void main() {
    import std.stdio: writeln;
    writeln(jaro(   "MARTHA",      "MARHTA"));
    writeln(jaro(    "DIXON",    "DICKSONX"));
    writeln(jaro("JELLYFISH",  "SMELLYFISH"));
}
