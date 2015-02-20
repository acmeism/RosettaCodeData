class SumMultiples {
	public static long getSum(long n) {
		long sum = 0;
		for (int i = 3; i < n; i++) {
			if (i % 3 == 0 || i % 5 == 0) sum += i;
		}
		return sum;
	}
	public static void main(String[] args) {
		System.out.println(getSum(1000));
	}
}
