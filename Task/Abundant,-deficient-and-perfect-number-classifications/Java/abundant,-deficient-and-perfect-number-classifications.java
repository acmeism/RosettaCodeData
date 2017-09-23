import java.util.stream.LongStream;

public class NumberClassifications {

    public static void main(String[] args) {
        int deficient = 0;
        int perfect = 0;
        int abundant = 0;

        for (long i = 1; i <= 20_000; i++) {
            long sum = properDivsSum(i);
            if (sum < i)
                deficient++;
            else if (sum == i)
                perfect++;
            else
                abundant++;
        }
        System.out.println("Deficient: " + deficient);
        System.out.println("Perfect: " + perfect);
        System.out.println("Abundant: " + abundant);
    }

    public static long properDivsSum(long n) {
        return LongStream.rangeClosed(1, (n + 1) / 2).filter(i -> n != i && n % i == 0).sum();
    }
}
