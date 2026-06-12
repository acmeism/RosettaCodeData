import java.util.*;

public class EBNFParser {
    // Type aliases equivalent
    private static class Token {
        Object value;
        boolean isSequence;

        Token(Object value, boolean isSequence) {
            this.value = value;
            this.isSequence = isSequence;
        }
    }

    private static class Sequence extends ArrayList<Object> {
        public Sequence(Object... items) {
            Collections.addAll(this, items);
        }
    }

    private String src;
    private char ch;
    private int sdx;
    private Token token;
    private boolean err = false;
    private List<String> idents = new ArrayList<>();
    private List<Integer> ididx = new ArrayList<>();
    private List<Sequence> productions = new ArrayList<>();
    private Sequence extras = new Sequence();
    private String[] results = {"pass", "fail"};

    private int btoi(boolean b) {
        return b ? 1 : 0;
    }

    private int invalid(String msg) {
        err = true;
        System.out.println(msg);
        sdx = src.length(); // set to eof
        return -1;
    }

    private void skipSpaces() {
        while (sdx < src.length()) {
            ch = src.charAt(sdx);
            if (" \t\r\n".indexOf(ch) == -1) {
                break;
            }
            sdx++;
        }
    }

    private void getToken() {
        // Yields a single character token, one of {}()[]|=.;
        // or {"terminal",string} or {"ident", string} or -1.
        skipSpaces();
        if (sdx >= src.length()) {
            token = new Token(-1, false);
            return;
        }
        int tokstart = sdx;
        if ("{}()[]|=.;".indexOf(ch) >= 0) {
            sdx++;
            token = new Token(ch, false);
        } else if (ch == '"' || ch == '\'') {
            char closech = ch;
            int tokend = tokstart + 1;
            while (tokend < src.length() && src.charAt(tokend) != closech) {
                tokend++;
            }
            if (tokend >= src.length()) {
                token = new Token(invalid("no closing quote"), false);
            } else {
                sdx = tokend + 1;
                token = new Token(new Sequence("terminal", src.substring(tokstart + 1, tokend)), true);
            }
        } else if (ch >= 'a' && ch <= 'z') {
            // To simplify things for the purposes of this task,
            // identifiers are strictly a-z only, not A-Z or 1-9.
            while (sdx < src.length() && ch >= 'a' && ch <= 'z') {
                sdx++;
                if (sdx < src.length()) {
                    ch = src.charAt(sdx);
                }
            }
            token = new Token(new Sequence("ident", src.substring(tokstart, sdx)), true);
        } else {
            token = new Token(invalid("invalid ebnf"), false);
        }
    }

    private void matchToken(char expectedCh) {
        if (!token.value.equals(expectedCh)) {
            token = new Token(invalid(String.format("invalid ebnf (%c expected)", expectedCh)), false);
        } else {
            getToken();
        }
    }

    private int addIdent(String ident) {
        int k = idents.indexOf(ident);
        if (k == -1) {
            idents.add(ident);
            k = idents.size() - 1;
            ididx.add(-1);
        }
        return k;
    }

    private Object factor() {
        Object res;
        if (token.isSequence) {
            Sequence t = (Sequence) token.value;
            if (t.get(0).equals("ident")) {
                int idx = addIdent((String) t.get(1));
                t.add(idx);
                token.value = t;
            }
            res = token.value;
            getToken();
        } else if (token.value.equals('[')) {
            getToken();
            res = new Sequence("optional", expression());
            matchToken(']');
        } else if (token.value.equals('(')) {
            getToken();
            res = expression();
            matchToken(')');
        } else if (token.value.equals('{')) {
            getToken();
            res = new Sequence("repeat", expression());
            matchToken('}');
        } else {
            throw new RuntimeException("invalid token in factor() function");
        }
        if (res instanceof Sequence && ((Sequence) res).size() == 1) {
            return ((Sequence) res).get(0);
        }
        return res;
    }

    private Object term() {
        Sequence res = new Sequence(factor());
        Object[] tokens = {-1, '|', '.', ';', ')', ']', '}'};

        outer:
        while (true) {
            for (Object t : tokens) {
                if (t.equals(token.value)) {
                    break outer;
                }
            }
            res.add(factor());
        }

        if (res.size() == 1) {
            return res.get(0);
        }
        return res;
    }

    private Object expression() {
        Sequence res = new Sequence(term());
        if (token.value.equals('|')) {
            res = new Sequence("or", res.get(0));
            while (token.value.equals('|')) {
                getToken();
                res.add(term());
            }
        }
        if (res.size() == 1) {
            return res.get(0);
        }
        return res;
    }

    private Object production() {
        // Returns a token or -1; the real result is left in 'productions' etc,
        getToken();
        if (!token.value.equals('}')) {
            if (token.value.equals(-1)) {
                return invalid("invalid ebnf (missing closing })");
            }
            if (!token.isSequence) {
                return -1;
            }
            Sequence t = (Sequence) token.value;
            if (!t.get(0).equals("ident")) {
                return -1;
            }
            String ident = (String) t.get(1);
            int idx = addIdent(ident);
            getToken();
            matchToken('=');
            if (token.value.equals(-1)) {
                return -1;
            }
            productions.add(new Sequence(ident, idx, expression()));
            ididx.set(idx, productions.size() - 1);
        }
        return token.value;
    }

    private int parse(String ebnf) {
        // Returns +1 if ok, -1 if bad.
        System.out.printf("parse:\n%s ===>\n", ebnf);
        err = false;
        src = ebnf;
        sdx = 0;
        idents.clear();
        ididx.clear();
        productions.clear();
        extras.clear();

        getToken();
        if (token.isSequence) {
            Sequence t = (Sequence) token.value;
            t.set(0, "title");
            extras.add(token.value);
            getToken();
        }
        if (!token.value.equals('{')) {
            return invalid("invalid ebnf (missing opening {)");
        }

        while (true) {
            Object tokenResult = production();
            if (tokenResult.equals('}') || tokenResult.equals(-1)) {
                break;
            }
        }

        getToken();
        if (token.isSequence) {
            Sequence t = (Sequence) token.value;
            t.set(0, "comment");
            extras.add(token.value);
            getToken();
        }
        if (!token.value.equals(-1)) {
            return invalid("invalid ebnf (missing eof?)");
        }
        if (err) {
            return -1;
        }

        int k = -1;
        for (int i = 0; i < ididx.size(); i++) {
            if (ididx.get(i) == -1) {
                k = i;
                break;
            }
        }
        if (k != -1) {
            return invalid(String.format("invalid ebnf (undefined:%s)", idents.get(k)));
        }

        pprint(productions, "productions");
        pprint(idents, "idents");
        pprint(ididx, "ididx");
        pprint(extras, "extras");
        return 1;
    }

    // Adjusts Java's normal printing to look more like Phix output.
    private void pprint(Object ob, String header) {
        System.out.printf("\n%s:\n", header);
        String pp = ob.toString();
        pp = pp.replace("[", "{");
        pp = pp.replace("]", "}");
        pp = pp.replace(" ", ", ");
        for (int i = 0; i < idents.size(); i++) {
            pp = pp.replace(String.valueOf(i), String.valueOf(i));
        }
        System.out.println(pp);
    }

    // The rules that applies() has to deal with are:
    // {factors} - if rule[0] is not string,
    // just apply one after the other recursively.
    // {"terminal", "a1"}       -- literal constants
    // {"or", <e1>, <e2>, ...}  -- (any) one of n
    // {"repeat", <e1>}         -- as per "{}" in ebnf
    // {"optional", <e1>}       -- as per "[]" in ebnf
    // {"ident", <name>, idx}   -- apply the sub-rule

    private boolean applies(Sequence rule) {
        int wasSdx = sdx; // in case of failure
        Object r1 = rule.get(0);

        if (!(r1 instanceof String)) {
            for (int i = 0; i < rule.size(); i++) {
                if (!applies((Sequence) rule.get(i))) {
                    sdx = wasSdx;
                    return false;
                }
            }
        } else if (r1.equals("terminal")) {
            skipSpaces();
            String r2 = (String) rule.get(1);
            for (int i = 0; i < r2.length(); i++) {
                if (sdx >= src.length() || src.charAt(sdx) != r2.charAt(i)) {
                    sdx = wasSdx;
                    return false;
                }
                sdx++;
            }
        } else if (r1.equals("or")) {
            for (int i = 1; i < rule.size(); i++) {
                if (applies((Sequence) rule.get(i))) {
                    return true;
                }
            }
            sdx = wasSdx;
            return false;
        } else if (r1.equals("repeat")) {
            while (applies((Sequence) rule.get(1))) {
                // continue repeating
            }
        } else if (r1.equals("optional")) {
            applies((Sequence) rule.get(1));
        } else if (r1.equals("ident")) {
            int i = (Integer) rule.get(2);
            int ii = ididx.get(i);
            if (!applies((Sequence) productions.get(ii).get(2))) {
                sdx = wasSdx;
                return false;
            }
        } else {
            throw new RuntimeException("invalid rule in applies() function");
        }
        return true;
    }

    private void checkValid(String test) {
        src = test;
        sdx = 0;
        boolean res = applies((Sequence) productions.get(0).get(2));
        skipSpaces();
        if (sdx < src.length()) {
            res = false;
        }
        System.out.printf("\"%s\", %s\n", test, results[1 - btoi(res)]);
    }

    public static void main(String[] args) {
        EBNFParser parser = new EBNFParser();

        String[] ebnfs = {
            "\"a\" {\n" +
            "    a = \"a1\" ( \"a2\" | \"a3\" ) { \"a4\" } [ \"a5\" ] \"a6\" ;\n" +
            "} \"z\" ",

            "{\n" +
            "    expr = term { plus term } .\n" +
            "    term = factor { times factor } .\n" +
            "    factor = number | '(' expr ')' .\n" +
            " \n" +
            "    plus = \"+\" | \"-\" .\n" +
            "    times = \"*\" | \"/\" .\n" +
            " \n" +
            "    number = digit { digit } .\n" +
            "    digit = \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | \"6\" | \"7\" | \"8\" | \"9\" .\n" +
            "}",

            "a = \"1\"",
            "{ a = \"1\" ;",
            "{ hello world = \"1\"; }",
            "{ foo = bar . }"
        };

        String[][] tests = {
            {
                "a1a3a4a4a5a6",
                "a1 a2a6",
                "a1 a3 a4 a6",
                "a1 a4 a5 a6",
                "a1 a2 a4 a5 a5 a6",
                "a1 a2 a4 a5 a6 a7",
                "your ad here"
            },
            {
                "2",
                "2*3 + 4/23 - 7",
                "(3 + 4) * 6-2+(4*(4))",
                "-2",
                "3 +",
                "(4 + 3"
            }
        };

        for (int i = 0; i < ebnfs.length; i++) {
            if (parser.parse(ebnfs[i]) == 1) {
                System.out.println("\ntests:");
                if (i < tests.length) {
                    for (String test : tests[i]) {
                        parser.checkValid(test);
                    }
                }
            }
            System.out.println();
        }
    }
}
