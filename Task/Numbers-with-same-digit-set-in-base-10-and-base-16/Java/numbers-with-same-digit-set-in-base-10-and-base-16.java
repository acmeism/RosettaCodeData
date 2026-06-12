import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.function.BiFunction;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class NumbersWithTheSameDigitSetInBase10AndBase16 {

	public static void main(String[] args) {
		BiFunction<Integer, Integer, Set<String>> digitSetInBase = (number, base) ->
			Arrays.stream(Integer.toString(number, base).split("")).collect(Collectors.toSet());
			
		List<Integer> results = IntStream.range(0, 100_000)
			.filter( i -> digitSetInBase.apply(i, 10).equals(digitSetInBase.apply(i, 16)) ).boxed().toList();
			
		IntStream.range(0, results.size()).forEach( i ->
			System.out.print(String.format("%5d%s", results.get(i), ( i % 10 == 9 ? "\n" : " " ))) );
	}

}
