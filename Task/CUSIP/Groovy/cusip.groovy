class Cusip {
    private static Boolean isCusip(String s) {
        if (s.length() != 9) return false
        int sum = 0
        for (int i = 0; i <= 7; i++) {
            char c = s.charAt(i)

            int v
            if (c >= ('0' as char) && c <= ('9' as char)) {
                v = c - 48
            } else if (c >= ('A' as char) && c <= ('Z' as char)) {
                v = c - 55  // lower case letters apparently invalid
            } else if (c == '*' as char) {
                v = 36
            } else if (c == '@' as char) {
                v = 37
            } else if (c == '#' as char) {
                v = 38
            } else {
                return false
            }
            if (i % 2 == 1) v *= 2  // check if odd as using 0-based indexing
            sum += v / 10 + v % 10
        }
        return s.charAt(8) - 48 == (10 - (sum % 10)) % 10
    }

    static void main(String[] args) {
        List<String> candidates=new ArrayList<>()
        candidates.add("037833100")
        candidates.add("17275R102")
        candidates.add("38259P508")
        candidates.add("594918104")
        candidates.add("68389X106")
        candidates.add("68389X105")
        for (String candidate : candidates) {
            System.out.printf("%s -> %s%n", candidate, isCusip(candidate) ? "correct" : "incorrect")
        }
    }
}
