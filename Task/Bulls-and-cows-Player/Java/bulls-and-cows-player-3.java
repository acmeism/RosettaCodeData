public class GameNumber extends AbstractGuessNumber {

    public GameNumber() {
        super(4);
        defineNumber();
    }

    public static boolean isGuess(int[] digits) {
        return (digits != null && isUnique(digits) && isAllDigits(digits));
    }

    protected static boolean isAllDigits(int[] array) {
        for (int i = 0; i < array.length; i++) {
            char digit = (char) (array[i] + '0');

            if (!Character.isDigit(digit)) {
                return false;
            }
        }
        return true;
    }

    protected static boolean isUnique(int[] array) {
        for (int j = 0; j < array.length; j++) {
            int a = array[j];

            for (int i = 0; i < j; i++) {
                if (a == array[i]) {
                    // seen this int before
                    return false;
                }
            }
        }
        return true;
    }

    public static int[] parseDigits(int number, int length) {
        int[] arr = new int[length];
        int temp = number;
        for (int i = length - 1; i >= 0; i--) {
            arr[i] = temp % 10;
            temp /= 10;
        }
        return arr;
    }

    protected void defineNumber() {
        int[] arr = generateRandom();

        for (int i = 0; i < getLength(); i++) {
            digits[i] = arr[i];
        }
    }

    private int[] generateRandom() {
        int[] arr;
        do {
            Random random = new Random();
            int number = random.nextInt(9877) + 123;
            arr = parseDigits(number, getLength());
        } while (!isGuess(arr));
        return arr;
    }

    @Override
    public String toString() {
        return Arrays.toString(digits);
    }
}
