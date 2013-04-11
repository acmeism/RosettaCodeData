import std.stdio, std.algorithm, std.conv;

string[] selfReferentialSeq(string n, string[] seen=[]) {
    static string[][string] cache;
    if (n in cache) return cache[n];
    if (canFind(seen, n)) return [];

    int[10] digit_count;
    foreach (d; n)
        digit_count[d - '0']++;
    string term;
    foreach_reverse (d; 0 .. 10)
        if (digit_count[d] > 0)
            term ~= text(digit_count[d], d);
    return cache[n] = [n] ~ selfReferentialSeq(term, [n] ~ seen);
}

void main() {
    enum int limit = 1_000_000;
    int max_len;
    int[] max_vals;

    foreach (n; 1 .. limit) {
        const seq = n.text().selfReferentialSeq();
        if (seq.length > max_len) {
            max_len = seq.length;
            max_vals = [n];
        } else if (seq.length == max_len)
            max_vals ~= n;
    }

    writeln("values: ", max_vals);
    writeln("iterations: ", max_len);
    writeln("sequence:");
    foreach (idx, val; max_vals[0].text().selfReferentialSeq())
        writefln("%2d %s", idx + 1, val);
}
