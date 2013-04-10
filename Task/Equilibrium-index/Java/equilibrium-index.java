import java.util.Arrays;

public class Equlibrium {
	private static int[] sequence = {-7, 1, 5, 2, -4, 3, 0};

	public static void main(String[] args) {
		System.out.println("Equilibrium indices of " + Arrays.toString(sequence)+":");
		for (int i = 0; i < sequence.length; i++) {
			int sum = 0;
			for (int j = 0; j < sequence.length; j++) {
				if (j < i)
					sum += sequence[j];
				if (j > i)
					sum -= sequence[j];
			}
			if (sum == 0)
				System.out.println(i);
		}
	}
}
