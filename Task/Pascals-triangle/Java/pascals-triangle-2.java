public class Pas{
	public static void main(String[] args){
		//usage
		pas(20);
	}

	public static void pas(int rows){
		for(int i = 0; i < rows; i++){
			for(int j = 0; j <= i; j++){
				System.out.print(ncr(i, j) + " ");
			}
			System.out.println();
		}
	}

	public static long ncr(int n, int r){
		return fact(n) / (fact(r) * fact(n - r));
	}

	public static long fact(int n){
		long ans = 1;
		for(int i = 2; i <= n; i++){
			ans *= i;
		}
		return ans;
	}
}
