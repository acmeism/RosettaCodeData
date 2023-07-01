public class BraceExpansion {

    public static void main(String[] args) {
        for (String s : new String[]{"It{{em,alic}iz,erat}e{d,}, please.",
            "~/{Downloads,Pictures}/*.{jpg,gif,png}",
            "{,{,gotta have{ ,\\, again\\, }}more }cowbell!",
            "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"}) {
            System.out.println();
            expand(s);
        }
    }

    public static void expand(String s) {
        expandR("", s, "");
    }

    private static void expandR(String pre, String s, String suf) {
        int i1 = -1, i2 = 0;
        String noEscape = s.replaceAll("([\\\\]{2}|[\\\\][,}{])", "  ");
        StringBuilder sb = null;

        outer:
        while ((i1 = noEscape.indexOf('{', i1 + 1)) != -1) {
            i2 = i1 + 1;
            sb = new StringBuilder(s);
            for (int depth = 1; i2 < s.length() && depth > 0; i2++) {
                char c = noEscape.charAt(i2);
                depth = (c == '{') ? ++depth : depth;
                depth = (c == '}') ? --depth : depth;
                if (c == ',' && depth == 1) {
                    sb.setCharAt(i2, '\u0000');
                } else if (c == '}' && depth == 0 && sb.indexOf("\u0000") != -1)
                    break outer;
            }
        }
        if (i1 == -1) {
            if (suf.length() > 0)
                expandR(pre + s, suf, "");
            else
                System.out.printf("%s%s%s%n", pre, s, suf);
        } else {
            for (String m : sb.substring(i1 + 1, i2).split("\u0000", -1))
                expandR(pre + s.substring(0, i1), m, s.substring(i2 + 1) + suf);
        }
    }
}
