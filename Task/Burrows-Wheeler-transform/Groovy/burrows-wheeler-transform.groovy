class BWT {
    private static final String STX = "\u0002"
    private static final String ETX = "\u0003"

    private static String bwt(String s) {
        if (s.contains(STX) || s.contains(ETX)) {
            throw new IllegalArgumentException("String cannot contain STX or ETX")
        }

        String ss = STX + s + ETX
        List<String> table = new ArrayList<>()
        for (int i = 0; i < ss.length(); i++) {
            String before = ss.substring(i)
            String after = ss.substring(0, i)
            table.add(before + after)
        }
        Collections.sort(table)

        StringBuilder sb = new StringBuilder()
        for (String str : table) {
            sb.append(str[str.length() - 1])
        }
        return sb.toString()
    }

    private static String ibwt(String r) {
        int len = r.length()
        List<String> table = new ArrayList<>()
        for (int i = 0; i < len; ++i) {
            table.add("")
        }
        for (int j = 0; j < len; ++j) {
            for (int i = 0; i < len; ++i) {
                table[i] = r[i] + table[i]
            }
            Collections.sort(table)
        }
        for (String row : table) {
            if (row.endsWith(ETX)) {
                return row.substring(1, len - 1)
            }
        }
        return ""
    }

    private static String makePrintable(String s) {
        // substitute ^ for STX and | for ETX to print results
        return s.replace(STX, "^").replace(ETX, "|")
    }

    static void main(String[] args) {
        List<String> tests = new ArrayList<>()
        tests.add("banana")
        tests.add("appellee")
        tests.add("dogwood")
        tests.add("TO BE OR NOT TO BE OR WANT TO BE OR NOT?")
        tests.add("SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES")
        tests.add("\u0002ABC\u0003")

        for (String test : tests) {
            println(makePrintable(test))
            print(" --> ")
            String t = ""
            try {
                t = bwt(test)
                println(makePrintable(t))
            } catch (IllegalArgumentException e) {
                println("ERROR: " + e.getMessage())
            }
            String r = ibwt(t)
            printf(" --> %s\n\n", r)
        }
    }
}
