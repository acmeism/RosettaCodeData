import java.util.HashMap;
import java.util.Map;
import java.util.stream.IntStream;

public class ExecutableLibrary {

    public static void main(String[] args) {
        Map<Integer,Integer> lengthMap = new HashMap<>();
        IntStream.range(1, 100_000)
                 .map(n -> HailstoneSequence.hailstoneSequence(n).size())
                 .forEach(len -> lengthMap.merge(len, 1, (v1, v2) -> v1 + v2));
        int mostOften = lengthMap.values()
                                 .stream()
                                 .mapToInt(x -> x)
                                 .max().orElse(-1);

        System.out.printf("The most frequent hailstone length for n < 100,000 is %d.%n", mostOften);
    }

}
