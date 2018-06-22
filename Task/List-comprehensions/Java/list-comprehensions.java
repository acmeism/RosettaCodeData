// Boilerplate
import java.util.Arrays;
import java.util.List;
import static java.util.function.Function.identity;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;
public interface PythagComp{
    static void main(String... args){
        System.out.println(run(20));
    }

    static List<List<Integer>> run(int n){
        return
            // Here comes the list comprehension bit
            // input stream - bit clunky
            range(1, n).mapToObj(
                x -> range(x, n).mapToObj(
                    y -> range(y, n).mapToObj(
                        z -> new Integer[]{x, y, z}
                    )
                )
            )
                .flatMap(identity())
                .flatMap(identity())
                // predicate
                .filter(a -> a[0]*a[0] + a[1]*a[1] == a[2]*a[2])
                // output expression
                .map(Arrays::asList)
                // the result is a list
                .collect(toList())
        ;
    }
}
