class Jaro {
    private static function jaro(s1: String, s2: String): Float {
        var s1_len = s1.length;
        var s2_len = s2.length;
        if (s1_len == 0 && s2_len == 0) return 1;

        var match_distance = Std.int(Math.max(s1_len, s2_len)) / 2 - 1;
        var matches = { s1: [for(n in 0...s1_len) false], s2: [for(n in 0...s2_len) false] };
        var m = 0;
        for (i in 0...s1_len) {
            var start = Std.int(Math.max(0, i - match_distance));
            var end = Std.int(Math.min(i + match_distance + 1, s2_len));
            for (j in start...end)
                if (!matches.s2[j] && s1.charAt(i) == s2.charAt(j)) {
	                matches.s1[i] = true;
	                matches.s2[j] = true;
	                m++;
	                break;
                }
        }
        if (m == 0) return 0;

        var k = 0;
        var t = 0.;
        for (i in 0...s1_len)
            if (matches.s1[i]) {
            	while (!matches.s2[k]) k++;
            	if (s1.charAt(i) != s2.charAt(k++)) t += 0.5;
            }

        return (m / s1_len + m / s2_len + (m - t) / m) / 3.0;
    }

    public static function main() {
        Sys.println(jaro(   "MARTHA",      "MARHTA"));
        Sys.println(jaro(    "DIXON",    "DICKSONX"));
        Sys.println(jaro("JELLYFISH",  "SMELLYFISH"));
    }
}
