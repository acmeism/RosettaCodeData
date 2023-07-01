public class AverageLoopLength {
	private static int N = 100000;
	
	private static double analytical(int n) {
		double[] factorial = new double[n + 1];
		double[] powers = new double[n + 1];
		powers[0] = 1.0;
		factorial[0] = 1.0;
		for (int i = 1; i <= n; i++) {
			factorial[i] = factorial[i - 1] * i;
			powers[i] = powers[i - 1] * n;
		}
		double sum = 0;
		
		for (int i = 1; i <= n; i++) {
			sum += factorial[n] / factorial[n - i] / powers[i];
		}
		return sum;
	}

	private static double average(int n) {
		Random rnd = new Random();
		double sum = 0.0;
		for (int a = 0; a < N; a++) {
			int[] random = new int[n];
			for (int i = 0; i < n; i++) {
				random[i] = rnd.Next(n);
			}
			var seen = new HashSet<double>(n);
			int current = 0;
			int length = 0;
			while (seen.Add(current)) {
				length++;
				current = random[current];
			}
			sum += length;
		}
		return sum / N;
	}
	
	public static void Main(string[] args) {
	Console.WriteLine(" N    average    analytical    (error)");
	Console.WriteLine("===  =========  ============  =========");
		for (int i = 1; i <= 20; i++) {
			var average = AverageLoopLength.average(i);
			var analytical = AverageLoopLength.analytical(i);
			Console.WriteLine("{0,3} {1,10:N4} {2,13:N4}  {3,8:N2}%", i, average, analytical, (analytical - average) / analytical * 100);
		}
	}
}
