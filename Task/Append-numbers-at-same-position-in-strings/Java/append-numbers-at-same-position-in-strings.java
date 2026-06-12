import java.util.List;
import java.util.stream.IntStream;

public final class AppendNumbersAtSamePositionInStrings {

    public static void main(String[] args) {
        List<Integer> one   = List.of( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
        List<Integer> two   = List.of( 10, 11, 12, 13, 14, 15, 16, 17, 18 );
        List<Integer> three = List.of( 19, 20, 21, 22, 23, 24, 25, 26, 27 );

        System.out.println(IntStream.range(0, one.size()).mapToObj(
            i -> String.format("%d%d%d", one.get(i), two.get(i), three.get(i)) ).toList());
    }

}
