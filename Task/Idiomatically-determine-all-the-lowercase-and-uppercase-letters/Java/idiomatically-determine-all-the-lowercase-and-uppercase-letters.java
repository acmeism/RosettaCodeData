import java.util.stream.IntStream;

public class Letters {
    public static void main(String[] args) throws Exception {
        System.out.print("Upper case: ");
        IntStream.rangeClosed(0, 0x10FFFF)
                 .filter(Character::isUpperCase)
                 .limit(72)
                 .forEach(n -> System.out.printf("%c", n));
        System.out.println("...");

        System.out.print("Lower case: ");
        IntStream.rangeClosed(0, 0x10FFFF)
                 .filter(Character::isLowerCase)
                 .limit(72)
                 .forEach(n -> System.out.printf("%c", n));
        System.out.println("...");
    }
}
