public class Int2Words {
    static String[] small = {"one", "two", "three", "four", "five", "six",
        "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"};
    static String[] tens = {"twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty",
        "ninety"};
    static String[] big = {"thousand", "million", "billion", "trillion"};

    public static void main(String[] args) {
        System.out.println(int2Text(900000001));
        System.out.println(int2Text(1234567890));
        System.out.println(int2Text(-987654321));
        System.out.println(int2Text(0));
    }

    public static String int2Text(long number) {
        long num = 0;
        String outP = "";
        int unit = 0;
        long tmpLng1 = 0;

        if (number == 0) {
            return "zero";
        }

        num = Math.abs(number);

        for (;;) {
            tmpLng1 = num % 100;
            if (tmpLng1 >= 1 && tmpLng1 <= 19) {
                outP = small[(int) tmpLng1 - 1] + " " + outP;
            } else if (tmpLng1 >= 20 && tmpLng1 <= 99) {
                if (tmpLng1 % 10 == 0) {
                    outP = tens[(int) (tmpLng1 / 10) - 2] + " " + outP;
                } else {
                    outP = tens[(int) (tmpLng1 / 10) - 2] + "-"
                            + small[(int) (tmpLng1 % 10) - 1] + " " + outP;
                }
            }

            tmpLng1 = (num % 1000) / 100;
            if (tmpLng1 != 0) {
                outP = small[(int) tmpLng1 - 1] + " hundred " + outP;
            }

            num /= 1000;
            if (num == 0) {
                break;
            }

            tmpLng1 = num % 1000;
            if (tmpLng1 != 0) {
                outP = big[unit] + " " + outP;
            }
            unit++;
        }

        if (number < 0) {
            outP = "negative " + outP;
        }

        return outP.trim();
    }
}
