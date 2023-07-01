import java.util.stream.IntStream;
class FizzBuzzJdk12 {
    public static void main(String[] args) {
        IntStream.range(1,101)
        .mapToObj(i->switch (i%15) {
            case 0 -> "FizzBuzz";
            case 3, 6, 9, 12 -> "Fizz";
            case 5, 10 -> "Buzz";
            default -> Integer.toString(i);
        })
        .forEach(System.out::println)
        ;
    }
}
