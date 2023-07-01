class BraceExpansion {
    static void main(String[] args) {
        for (String s : [
                "It{{em,alic}iz,erat}e{d,}, please.",
                "~/{Downloads,Pictures}/*.{jpg,gif,png}",
                "{,{,gotta have{ ,\\, again\\, }}more }cowbell!",
                "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"
        ]) {
            println()
            expand(s)
        }
    }

    static void expand(String s) {
        expandR("", s, "")
    }

    private static void expandR(String pre, String s, String suf) {
        int i1 = -1, i2 = 0
        String noEscape = s.replaceAll("([\\\\]{2}|[\\\\][,}{])", "  ")
        StringBuilder sb = null

        outer:
        while ((i1 = noEscape.indexOf('{', i1 + 1)) != -1) {
            i2 = i1 + 1
            sb = new StringBuilder(s)
            for (int depth = 1; i2 < s.length() && depth > 0; i2++) {
                char c = noEscape.charAt(i2)
                depth = (c == ('{' as char)) ? ++depth : depth
                depth = (c == ('}' as char)) ? --depth : depth
                if (c == (',' as char) && depth == 1) {
                    sb.setCharAt(i2, '\u0000' as char)
                } else if (c == ('}' as char) && depth == 0 && sb.indexOf("\u0000") != -1) {
                    break outer
                }
            }
        }
        if (i1 == -1) {
            if (suf.length() > 0) {
                expandR(pre + s, suf, "")
            } else {
                printf("%s%s%s%n", pre, s, suf)
            }
        } else {
            for (String m : sb.substring(i1 + 1, i2).split("\u0000", -1)) {
                expandR(pre + s.substring(0, i1), m, s.substring(i2 + 1) + suf)
            }
        }
    }
}
