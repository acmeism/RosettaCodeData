import java.util.stream.IntStream;
public class NarcissisticNumbers {
    static int numbersToCalculate = 25;
    static int numbersCalculated = 0;

    public static void main(String[] args) {
        IntStream.iterate(0, n -> n + 1).limit(Integer.MAX_VALUE).boxed().forEach(i -> {
            int length = i.toString().length();
            int addedDigits = 0;

            for (int count = 0; count < length; count++) {
                int value = Integer.parseInt(String.valueOf(i.toString().charAt(count)));
                addedDigits += Math.pow(value, length);
            }

            if (i == addedDigits) {
                numbersCalculated++;
                System.out.print(addedDigits + " ");
            }

            if (numbersCalculated == numbersToCalculate) {
                System.exit(0);
            }
        });
    }
}
