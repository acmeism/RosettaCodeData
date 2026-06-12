bool isPrime(int n) {
	if (n < 2) {
		return false;
	}
	if (!(n%2)) {
		return n == 2;
	}
	if (!(n%3)) {
		return n == 3;
	}

	int d = 5;
	
	while(d*d <= n) {
		if (!(n%d)) {
			return false;
		}
		d += 2;
		if (!(n%d)) {
			return false;
		}
		d += 4;
	 }
	return true;
}

int main() {
	int limit = 12;

	write("The first " + (string)limit + " prime Fibonacci numbers are:\n");

	int count = 0;
	int f1, f2;
	f1 = f2 = 1;

	while(count < limit) {
		int f3 = f2 + f1;
		if (isPrime(f3)) {
			write((string)f3 + " ");
			count = count + 1;
		}
		f1 = f2;
		f2 = f3;
	}
	write("\n");
	return 0;
}
