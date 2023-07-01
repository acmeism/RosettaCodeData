public class MultiFact {
	private static long multiFact(long n, int deg){
		long ans = 1;
		for(long i = n; i > 0; i -= deg){
			ans *= i;
		}
		return ans;
	}
	
	public static void main(String[] args){
		for(int deg = 1; deg <= 5; deg++){
			System.out.print("degree " + deg + ":");
			for(long n = 1; n <= 10; n++){
				System.out.print(" " + multiFact(n, deg));
			}
			System.out.println();
		}
	}
}
