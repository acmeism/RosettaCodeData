int product_of_divisors(int n) {
	int ans, i, j;
	ans = i = j = 1;

	while(i * i <= n) {
		if(n%i == 0) {
			ans = ans * i;
			j = n / i;
			if(j != i) {
				ans = ans * j;
			}
		}
		i = i+1;
	}

	return ans;
}

int main() {
	int limit = 50;
	write("Product of divisors for the first " + (string)limit + " positive integers:\n");
	for(int i = 1; i < limit + 1; i++) {
		write("%11d", product_of_divisors(i));
		if(i%5 == 0) {
			write("\n");
		}
	}
	return 0;
}
