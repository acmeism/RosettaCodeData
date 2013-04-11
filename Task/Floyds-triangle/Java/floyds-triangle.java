public class Floyd {
	public static void main(String[] args){
		System.out.println("5 rows:");
		printTriangle(5);
		System.out.println("14 rows:");
		printTriangle(14);
	}
	
	private static void printTriangle(int n){
		for(int rowNum = 1, printMe = 1, numsPrinted = 0;
				rowNum <= n; printMe++){
			int cols = (int)Math.ceil(Math.log10(n*(n-1)/2 + numsPrinted + 2));
			System.out.printf("%"+cols+"d ", printMe);
			if(++numsPrinted == rowNum){
				System.out.println();
				rowNum++;
				numsPrinted = 0;
			}
		}
	}
}
