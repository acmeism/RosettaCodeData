import java.util.Arrays;
import java.util.function.Function;

public class PartialApplication {
	// Original method fs(f, s).
	static Integer[] fs(Function<Integer, Integer> f, Integer[] s) {
		Integer[] r = new Integer[s.length];
		for (int i = 0; i < s.length; i++)
			r[i] = f.apply(s[i]);
		return r;		
	}

	// Curried method fs(f).apply(s),
	// necessary for partial application.
	static Function<Integer[], Integer[]> fs(Function<Integer, Integer> f) {
		return s -> fs(f, s);
	}

	static Function<Integer, Integer> f1 = i -> i * 2;

	static Function<Integer, Integer> f2 = i -> i * i;

	static Function<Integer[], Integer[]> fsf1 = fs(f1); // Partial application.

	static Function<Integer[], Integer[]> fsf2 = fs(f2);

	public static void main(String[] args) {
		Integer[][] sequences = {
			{ 0, 1, 2, 3 },
			{ 2, 4, 6, 8 },
		};

		for (Integer[] array : sequences) {
			System.out.printf(
			    "array: %s\n" +
			    "  fsf1(array): %s\n" +
			    "  fsf2(array): %s\n",
			    Arrays.toString(array),
			    Arrays.toString(fsf1.apply(array)),
			    Arrays.toString(fsf2.apply(array)));
		}
	}
}
