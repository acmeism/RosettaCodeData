import java.util.Arrays;

public class PartialApplication {
	interface IntegerFunction {
		int call(int arg);
	}

	// Original method fs(f, s).
	static int[] fs(IntegerFunction f, int[] s) {
		int[] r = new int[s.length];
		for (int i = 0; i < s.length; i++)
			r[i] = f.call(s[i]);
		return r;		
	}

	interface SequenceFunction {
		int[] call(int[] arg);
	}

	// Curried method fs(f).call(s),
	// necessary for partial application.
	static SequenceFunction fs(final IntegerFunction f) {
		return new SequenceFunction() {
			public int[] call(int[] s) {
				// Call original method.
				return fs(f, s);
			}
		};
	}

	static IntegerFunction f1 = new IntegerFunction() {
		public int call(int i) {
			return i * 2;
		}
	};

	static IntegerFunction f2 = new IntegerFunction() {
		public int call(int i) {
			return i * i;
		}
	};

	static SequenceFunction fsf1 = fs(f1); // Partial application.

	static SequenceFunction fsf2 = fs(f2);

	public static void main(String[] args) {
		int[][] sequences = {
			{ 0, 1, 2, 3 },
			{ 2, 4, 6, 8 },
		};

		for (int[] array : sequences) {
			System.out.printf(
			    "array: %s\n" +
			    "  fsf1(array): %s\n" +
			    "  fsf2(array): %s\n",
			    Arrays.toString(array),
			    Arrays.toString(fsf1.call(array)),
			    Arrays.toString(fsf2.call(array)));
		}
	}
}
