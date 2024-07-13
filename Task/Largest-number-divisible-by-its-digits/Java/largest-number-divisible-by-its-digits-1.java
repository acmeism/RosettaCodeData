public class LynchBell {

    static String s = "";

    public static void main(String args[]) {
        //Highest number with unique digits (no 0 or 5)
        int i = 98764321;
        boolean isUnique = true;
        boolean canBeDivided = true;
        while (i>0) {
            s = String.valueOf(i);
            isUnique = uniqueDigits(i);
            if (isUnique) {
                //Number has unique digits
                canBeDivided = testNumber(i);
                if(canBeDivided) {
                    System.out.println("Number found: " + i);
                    i=0;
                }
            }
            i--;
        }
    }

    public static boolean uniqueDigits(int i) {
        //returns true, if unique digits, false otherwise
        for (int k = 0; k<s.length();k++) {
            for(int l=k+1; l<s.length();l++) {
                if(s.charAt(l)=='0' || s.charAt(l)=='5') {
                    //0 or 5 is a digit
                    return false;
                }
                if(s.charAt(k) == s.charAt(l)) {
                    //non-unique digit
                    return false;
                }
            }
        }
        return true;
    }

    public static boolean testNumber(int i) {
        //Tests, if i is divisible by all its digits (0 is not a digit already)
        int j = 0;
        boolean divisible = true;
        // TODO: divisible by all its digits
        for (char ch: s.toCharArray()) {
            j = Character.getNumericValue(ch);
            divisible = ((i%j)==0);
            if (!divisible) {
                return false;
            }
        }
        return true;
    }
}
