public class RepString {

    static final String[] input = {"1001110011", "1110111011", "0010010010",
        "1010101010", "1111111111", "0100101101", "0100100", "101", "11",
        "00", "1", "0100101"};

    public static void main(String[] args) {
        for (String s : input)
            System.out.printf("%s : %s%n", s, repString(s));
    }

    static String repString(String s) {
        int len = s.length();
        outer:
        for (int part = len / 2; part > 0; part--) {
            int tail = len % part;
            if (tail > 0 && !s.substring(0, tail).equals(s.substring(len - tail)))
                continue;
            for (int j = 0; j < len / part - 1; j++) {
                int a = j * part;
                int b = (j + 1) * part;
                int c = (j + 2) * part;
                if (!s.substring(a, b).equals(s.substring(b, c)))
                    continue outer;
            }
            return s.substring(0, part);
        }
        return "none";
    }
}
