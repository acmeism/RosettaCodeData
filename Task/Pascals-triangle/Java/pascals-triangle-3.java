public class Pascal {
	private static void printPascalLine (int n) {
		if (n < 1)
			return;
		int m = 1;
		System.out.print("1 ");
		for (int j=1; j<n; j++) {
			m = m * (n-j)/j;
			System.out.print(m);
			System.out.print(" ");
		}
		System.out.println();
	}
	
	public static void printPascal (int nRows) {
		for(int i=1; i<=nRows; i++)
			printPascalLine(i);
	}
}
