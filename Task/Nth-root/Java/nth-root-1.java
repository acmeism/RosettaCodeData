public static double nthroot(int n, double A) {
	return nthroot(n, A, .001);
}
public static double nthroot(int n, double A, double p) {
	if(A < 0) {
		System.err.println("A < 0");// we handle only real positive numbers
		return -1;
	} else if(A == 0) {
		return 0;
	}
	double x_prev = A;
	double x = A / n;  // starting "guessed" value...
	while(Math.abs(x - x_prev) > p) {
		x_prev = x;
		x = ((n - 1.0) * x + A / Math.pow(x, n - 1.0)) / n;
	}
	return x;
}
