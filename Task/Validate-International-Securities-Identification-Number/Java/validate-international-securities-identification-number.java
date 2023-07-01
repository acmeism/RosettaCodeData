public class ISIN {

    public static void main(String[] args) {
        String[] isins = {
            "US0378331005",
            "US0373831005",
            "U50378331005",
            "US03378331005",
            "AU0000XVGZA3",
            "AU0000VXGZA3",
            "FR0000988040"
        };
        for (String isin : isins)
            System.out.printf("%s is %s\n", isin, ISINtest(isin) ? "valid" : "not valid");
    }

    static boolean ISINtest(String isin) {
        isin = isin.trim().toUpperCase();

        if (!isin.matches("^[A-Z]{2}[A-Z0-9]{9}\\d$"))
            return false;

        StringBuilder sb = new StringBuilder();
        for (char c : isin.substring(0, 12).toCharArray())
            sb.append(Character.digit(c, 36));

        return luhnTest(sb.toString());
    }

    static boolean luhnTest(String number) {
        int s1 = 0, s2 = 0;
        String reverse = new StringBuffer(number).reverse().toString();
        for (int i = 0; i < reverse.length(); i++){
            int digit = Character.digit(reverse.charAt(i), 10);
            //This is for odd digits, they are 1-indexed in the algorithm.
            if (i % 2 == 0){
                s1 += digit;
            } else { // Add 2 * digit for 0-4, add 2 * digit - 9 for 5-9.
                s2 += 2 * digit;
                if(digit >= 5){
                    s2 -= 9;
                }
            }
        }
        return (s1 + s2) % 10 == 0;
    }
}
