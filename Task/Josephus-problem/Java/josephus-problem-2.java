import java.util.ArrayList;
import java.util.List;

public class Josephus {

	public static void main(String[] args) {
		execute(5, 1);
		execute(41, 2);
		execute(23482, 3342, 3);
	}

	public static int[][] execute(int n, int k) {
		return execute(n, k, 1);
	}

	public static int[][] execute(int n, int k, int s) {
		List<Integer> ps = new ArrayList<Integer>(n);
		for (int i=0; i<n; i+=1) ps.add(i);
		List<Integer> ks = new ArrayList<Integer>(n-s);
		for (int i=k; ps.size()>s; i=(i+k)%ps.size()) ks.add(ps.remove(i));
		System.out.printf("Josephus(%d,%d,%d) -> %s / %s\n", n, k, s, toString(ps), toString(ks));
		return new int[][] {
			ps.stream().mapToInt(Integer::intValue).toArray(),
			ks.stream().mapToInt(Integer::intValue).toArray()
		};
	}
	
	private static String toString(List <Integer> ls) {
		String dot = "";
		if (ls.size() >= 45) {
			dot = ", ...";
			ls = ls.subList(0, 45);
		}
		String s = ls.toString();
		return s.substring(1, s.length()-1) + dot;
	}
}
