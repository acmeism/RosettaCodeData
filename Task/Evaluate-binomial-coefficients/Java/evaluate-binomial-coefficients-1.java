public class Binom {

	static long combinations(int n, int k) {
		long coeff = 1;
		for (int i = n - k + 1; i <= n; i++) {
			coeff *= i;
		}
		for (int i = 1; i <= k; i++) {
			coeff /= i;
		}
		return coeff;
	}

    public static void main(String[] args){
        System.out.println(combinations(5, 3));
    }
}
