class LevenshteinDistance : Object {
    public static int compute (owned string s, owned string t, bool case_sensitive = false) {
        var n = s.length;
        var m = t.length;
        var d = new int[n + 1, m + 1];
        if (case_sensitive == false) {
            s = s.down ();
            t = t.down ();
        }
        if (n == 0) {
            return m;
        }
        if (m == 0) {
            return n;
        }
        for (var i = 0; i <= n; d[i, 0] = i++) {}
        for (var j = 0; j <= m; d[0, j] = j++) {}
        for (var i = 1; i <= n; i++) {
            for (var j = 1; j <= m; j++) {
                var cost = (t[j - 1] == s[i - 1]) ? 0 : 1;
                d[i, j] = int.min (int.min (d[i - 1, j] + 1, d[i, j - 1] + 1), d[i - 1, j - 1] + cost);
            }
        }
        return d[n, m];
    }
}
