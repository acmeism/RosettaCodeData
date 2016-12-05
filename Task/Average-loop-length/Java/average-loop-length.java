import java.util.ArrayList;

public class AverageLoopLength {
	private static final int N = 100000;
	//analytical(n) = sum_(i=1)^n (n!/(n-i)!/n**i)
	public static float analytical(int n){
		float[] factorial = new float[n+1];
		float[] powers = new float[n+1];
		factorial[0] = powers[0] = 1;
		for(int i=1;i<=n;i++){
			factorial[i] = factorial[i-1] * i;
			powers[i] = powers[i-1] * n;
		}
		float sum = 0;
		//memoized factorial and powers
		for(int i=1;i<=n;i++){
			sum += factorial[n]/factorial[n-i]/powers[i];
		}
		return sum;
	}
	public static float average(int n){
		float sum = 0;
		for(int a=0;a<N;a++){
			int[] random = new int[n];
			for(int i=0;i<n;i++){
				random[i] = (int)(Math.random()*n);
			}
			ArrayList<Integer> seen = new ArrayList<>(n);
			int current = 0;
			int length = 0;
			while(true){
				length++;
				seen.add(current);
				current = random[current];
				if(seen.contains(current)){
					break;
				}
			}
			sum += length;
		}
		return sum/N;
	}
	public static void main(String args[]){
		System.out.println(" N    average    analytical    (error)\n===  =========  ============  =========");
		for(int i=1;i<=20;i++){
			float avg = average(i);
			float ana = analytical(i);
			System.out.println(String.format("%3d  %9.4f  %12.4f  (%6.2f%%)",i,avg,ana,((ana-avg)/ana*100)));;
		}
	}
}
