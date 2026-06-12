import java.util.*;

public class BraceExpansion {
    static int sign(int n) {
        if (n < 0) return -1;
        if (n > 0) return 1;
        return 0;
    }

    static int abs(int n) {
        return n < 0 ? -n : n;
    }

    static List<String> parseRange(String r) {
        if (r.isEmpty()) {
            return Collections.singletonList("{}");
        }
        String[] parts = r.split("\\.\\.", -1);
        if (parts.length == 1) {
            return Collections.singletonList("{" + r + "}");
        }
        String start = parts[0];
        String end = parts[1];
        String incStr = parts.length > 2 ? parts[2] : "1";
        int inc;
        try {
            inc = Integer.parseInt(incStr);
        } catch (NumberFormatException e) {
            return Collections.singletonList("{" + r + "}");
        }
        Integer startNum = null, endNum = null;
        boolean startNumeric = false, endNumeric = false;
        try {
            startNum = Integer.parseInt(start);
            startNumeric = true;
        } catch (NumberFormatException e) {}
        try {
            endNum = Integer.parseInt(end);
            endNumeric = true;
        } catch (NumberFormatException e) {}
        boolean numeric = startNumeric && endNumeric;

        if (!numeric) {
            // Mixed numeric/alpha not expanded
            if ((startNumeric && !endNumeric) || (!startNumeric && endNumeric)) {
                return Collections.singletonList("{" + r + "}");
            }
            // Need single codepoint for each
            int startCpCount = start.codePointCount(0, start.length());
            int endCpCount = end.codePointCount(0, end.length());
            if (startCpCount != 1 || endCpCount != 1) {
                return Collections.singletonList("{" + r + "}");
            }
        }

        int n1, n2;
        int width = 1;
        if (numeric) {
            n1 = startNum;
            n2 = endNum;
            width = Math.max(start.length(), end.length());
        } else {
            n1 = start.codePointAt(0);
            n2 = end.codePointAt(0);
        }

        if (inc == 0) {
            if (numeric) {
                return Collections.singletonList(String.format("%0" + width + "d", n1));
            } else {
                return Collections.singletonList(start);
            }
        }

        boolean asc = n1 < n2;
        if (inc < 0) {
            asc = !asc;
            int t = n1;
            int d = abs(n1 - n2) % (-inc);
            n1 = n2 - d * sign(n2 - n1);
            n2 = t;
            inc = -inc;
        }

        List<String> res = new ArrayList<>();
        if (asc) {
            for (int i = n1; i <= n2; i += inc) {
                if (numeric) {
                    res.add(String.format("%0" + width + "d", i));
                } else {
                    res.add(new String(Character.toChars(i)));
                }
            }
        } else {
            for (int i = n1; i >= n2; i -= inc) {
                if (numeric) {
                    res.add(String.format("%0" + width + "d", i));
                } else {
                    res.add(new String(Character.toChars(i)));
                }
            }
        }
        return res;
    }

    static List<String> rangeExpand(String s) {
        List<String> res = new ArrayList<>();
        res.add("");
        StringBuilder rng = new StringBuilder();
        boolean inRng = false;
        for (int cp : s.codePoints().toArray()) {
            if (cp == '{' && !inRng) {
                inRng = true;
                rng.setLength(0);
            } else if (cp == '}' && inRng) {
                List<String> expanded = parseRange(rng.toString());
                List<String> newRes = new ArrayList<>();
                for (String prefix : res) {
                    for (String suffix : expanded) {
                        newRes.add(prefix + suffix);
                    }
                }
                res = newRes;
                inRng = false;
            } else if (inRng) {
                rng.appendCodePoint(cp);
            } else {
                // outside braces, append to each result
                String ch = new String(Character.toChars(cp));
                for (int i = 0; i < res.size(); i++) {
                    res.set(i, res.get(i) + ch);
                }
            }
        }
        if (inRng) {
            // unmatched braces, keep them literal
            String prefix = "{" + rng.toString();
            for (int i = 0; i < res.size(); i++) {
                res.set(i, res.get(i) + prefix);
            }
        }
        return res;
    }

    public static void main(String[] args) {
        String[] examples = {
            "simpleNumberRising{1..3}.txt",
            "simpleAlphaDescending-{Z..X}.txt",
            "steppedDownAndPadded-{10..00..5}.txt",
            "minusSignFlipsSequence {030..20..-5}.txt",
            "reverseSteppedNumberRising{1..6..-2}.txt",
            "combined-{Q..P}{2..1}.txt",
            "emoji{🌵..🌶}{🌽..🌾}etc",
            "li{teral",
            "rangeless{}empty",
            "rangeless{random}string",
            "mixedNumberAlpha{5..k}",
            "steppedAlphaRising{P..Z..2}.txt",
            "stops after endpoint-{02..10..3}.txt",
            "steppedNumberRising{1..6..2}.txt",
            "steppedNumberDescending{20..9..2}",
            "steppedAlphaDescending-{Z..M..2}.txt",
            "reversedSteppedAlphaDescending-{Z..M..-2}.txt"
        };
        for (String s : examples) {
            System.out.print(s + " ->\n    ");
            List<String> res = rangeExpand(s);
            String joined = String.join("\n    ", res);
            System.out.println(joined);
            System.out.println();
        }
    }
}

