public class AutoGuessNumber extends AbstractGuessNumber {

    public AutoGuessNumber(int number, int lenght) {
        super(lenght);
        defineNumber(number);
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

    protected void defineNumber(int number) {
        int[] arr = parseDigits(number, getLength());

        for (int i = 0; i < getLength(); i++) {
            digits[i] = arr[i];
        }
    }

    @Override
    public String toString() {
        return Arrays.toString(digits);
    }
}
