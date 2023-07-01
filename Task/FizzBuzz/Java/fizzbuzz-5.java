import java.util.stream.IntStream;

class FizzBuzzJdk12 {
    static final int FIZZ_FLAG = 0x8000_0000;
    static final int BUZZ_FLAG = 0x4000_0000;
    static final int FIZZ_BUZZ_FLAG = FIZZ_FLAG|BUZZ_FLAG;
    static final int[] FLAGS = new int[] {
        FIZZ_BUZZ_FLAG|0, 1, 2, FIZZ_FLAG|3, 4,
        BUZZ_FLAG|5, FIZZ_FLAG|6, 7, 8, FIZZ_FLAG|9,
        BUZZ_FLAG|10, 11, FIZZ_FLAG|12, 13, 14
    };
    public static void main(String[] args) {
    IntStream.iterate(0,i->++i)
       .flatMap(i -> IntStream.range(0,15).map(j->FLAGS[j]+15*i))
       .mapToObj(
        // JDK12 switch expression ...
        n-> switch(n & FIZZ_BUZZ_FLAG) {
            case FIZZ_BUZZ_FLAG -> "fizzbuzz";
            case FIZZ_FLAG -> "fizz";
            case BUZZ_FLAG -> "buzz";
            default -> Integer.toString(~FIZZ_BUZZ_FLAG & n);
            }
       )
       .skip(1)
       .limit(100)
       .forEach(System.out::println)
       ;
    }
}
