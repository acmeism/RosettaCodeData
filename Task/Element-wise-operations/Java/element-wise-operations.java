import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.function.BiFunction;
import java.util.stream.Stream;

@SuppressWarnings("serial")
public class ElementWiseOp {
	static final Map<String, BiFunction<Double, Double, Double>> OPERATIONS = new HashMap<String, BiFunction<Double, Double, Double>>() {
		{
			put("add", (a, b) -> a + b);
			put("sub", (a, b) -> a - b);
			put("mul", (a, b) -> a * b);
			put("div", (a, b) -> a / b);
			put("pow", (a, b) -> Math.pow(a, b));
			put("mod", (a, b) -> a % b);
		}
	};
	public static Double[][] scalarOp(String op, Double[][] matr, Double scalar) {
		BiFunction<Double, Double, Double> operation = OPERATIONS.getOrDefault(op, (a, b) -> a);
		Double[][] result = new Double[matr.length][matr[0].length];
		for (int i = 0; i < matr.length; i++) {
			for (int j = 0; j < matr[i].length; j++) {
				result[i][j] = operation.apply(matr[i][j], scalar);
			}
		}
		return result;
	}
	public static Double[][] matrOp(String op, Double[][] matr, Double[][] scalar) {
		BiFunction<Double, Double, Double> operation = OPERATIONS.getOrDefault(op, (a, b) -> a);
		Double[][] result = new Double[matr.length][Stream.of(matr).mapToInt(a -> a.length).max().getAsInt()];
		for (int i = 0; i < matr.length; i++) {
			for (int j = 0; j < matr[i].length; j++) {
				result[i][j] = operation.apply(matr[i][j], scalar[i % scalar.length][j
						% scalar[i % scalar.length].length]);
			}
		}
		return result;
	}
	public static void printMatrix(Double[][] matr) {
		Stream.of(matr).map(Arrays::toString).forEach(System.out::println);
	}
	public static void main(String[] args) {
		printMatrix(scalarOp("mul", new Double[][] {
				{ 1.0, 2.0, 3.0 },
				{ 4.0, 5.0, 6.0 },
				{ 7.0, 8.0, 9.0 }
		}, 3.0));

		printMatrix(matrOp("div", new Double[][] {
				{ 1.0, 2.0, 3.0 },
				{ 4.0, 5.0, 6.0 },
				{ 7.0, 8.0, 9.0 }
		}, new Double[][] {
				{ 1.0, 2.0},
				{ 3.0, 4.0}
		}));
	}
}
