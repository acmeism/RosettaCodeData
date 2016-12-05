import static java.util.stream.LongStream.rangeClosed;

public class NumberClassifications {

    public static void main(String[] args) {
        int countDeficient = 0;
        int countPerfect = 0;
        int countAbundant = 0;

        for (long i = 1; i <= 20_000L; i++) {
            long sum = properDivsSum(i);
            if (sum < i)
                countDeficient++;
            else if (sum == i)
                countPerfect++;
            else
                countAbundant++;
        }
        System.out.println("Deficient: " + countDeficient);
        System.out.println("Perfect: " + countPerfect);
        System.out.println("Abundant: " + countAbundant);
    }

    public static Long properDivsSum(long n) {
        return rangeClosed(1, (n + 1) / 2).filter(i -> n % i == 0 && n != i).sum();
    }
}
