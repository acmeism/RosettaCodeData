import static java.lang.Math.abs;
import static java.lang.Math.max;

public class Levenshtein {

	public static int ld(String a, String b) {
		return distance(a, b, -1);
	}
	public static boolean ld(String a, String b, int max) {
		return distance(a, b, max) <= max;
	}
	
	private static int distance(String a, String b, int max) {
		if (a == b) return 0;
		int la = a.length();
		int lb = b.length();
		if (max >= 0 && abs(la - lb) > max) return max+1;
		if (la == 0) return lb;
		if (lb == 0) return la;
		if (la < lb) {
			int tl = la; la = lb; lb = tl;
			String ts = a;  a = b; b = ts;
		}
		
		int[] cost = new int[lb+1];
		for (int i=0; i<=lb; i+=1) {
			cost[i] = i;
		}

		for (int i=1; i<=la; i+=1) {
			cost[0] = i;
			int prv = i-1;
			int min = prv;
			for (int j=1; j<=lb; j+=1) {
				int act = prv + (a.charAt(i-1) == b.charAt(j-1) ? 0 : 1);
				cost[j] = min(1+(prv=cost[j]), 1+cost[j-1], act);
				if (prv < min) min = prv;
			}
			if (max >= 0 && min > max) return max+1;
		}
		if (max >= 0 && cost[lb] > max) return max+1;
		return cost[lb];	
	}
	
	private static int min(int ... a) {
		int min = Integer.MAX_VALUE;
		for (int i: a) if (i<min) min = i;
		return min;
	}
	
	public static void main(String[] args) {
		System.out.println(
			ld("kitten","kitten") + " " + // 0
			ld("kitten","sitten") + " " + // 1
			ld("kitten","sittes") + " " + // 2
			ld("kitten","sityteng") + " " + // 3
			ld("kitten","sittYing") + " " + // 4
			ld("rosettacode","raisethysword") + " " + // 8
			ld("kitten","kittenaaaaaaaaaaaaaaaaa") + " " + // 17
			ld("kittenaaaaaaaaaaaaaaaaa","kitten") // 17
		);
		System.out.println(
			ld("kitten","kitten", 3) + " " + // true
			ld("kitten","sitten", 3) + " " + // true
			ld("kitten","sittes", 3) + " " + // true
			ld("kitten","sityteng", 3) + " " + // true
			ld("kitten","sittYing", 3) + " " + // false
			ld("rosettacode","raisethysword", 3) + " " + // false
			ld("kitten","kittenaaaaaaaaaaaaaaaaa", 3) + " " + // false
			ld("kittenaaaaaaaaaaaaaaaaa","kitten", 3) // false
		);
	}
}
