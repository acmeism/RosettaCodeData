public class AksTest
{
	static Long[] c = new Long[100];
	
	public static void main(String[] args)
	{
		for (int n = 0; n < 10; n++) {
			coef(n);
			System.out.print("(x-1)^" + n + " = ");
			show(n);
			System.out.println("");
		}
	
		System.out.print("Primes:");
		for (int n = 1; n <= 63; n++)
			if (is_prime(n))
				System.out.printf(" %d", n);
	
		System.out.println('\n');
	}
	
	static void coef(int n)
	{
		int i, j;
	
		if (n < 0 || n > 63) System.exit(0); // gracefully deal with range issue
	
		for (c[i=0] = 1l; i < n; c[0] = -c[0], i++)
			for (c[1 + (j=i)] = 1l; j > 0; j--)
				c[j] = c[j-1] - c[j];
	}
	
	static boolean is_prime(int n)
	{
		int i;
	
		coef(n);
		c[0] += 1;
		c[i=n] -= 1;
		
		while (i-- != 0 && (c[i] % n) == 0);
	
		return i < 0;
	}
	
	static void show(int n)
	{
		do {
			System.out.print("+" + c[n] + "x^"+ n);
		}while (n-- != 0);
	}
}
