def lcs(xstr, ystr) {
    if (xstr == "" || ystr == "") {
        return "";
    }

    def x = xstr[0];
    def y = ystr[0];

    def xs = xstr.size() > 1 ? xstr[1..-1] : "";
    def ys = ystr.size() > 1 ? ystr[1..-1] : "";

    if (x == y) {
        return (x + lcs(xs, ys));
    }

    def lcs1 = lcs(xstr, ys);
    def lcs2 = lcs(xs, ystr);

    lcs1.size() > lcs2.size() ? lcs1 : lcs2;
}

println(lcs("1234", "1224533324"));
println(lcs("thisisatest", "testing123testing"));
