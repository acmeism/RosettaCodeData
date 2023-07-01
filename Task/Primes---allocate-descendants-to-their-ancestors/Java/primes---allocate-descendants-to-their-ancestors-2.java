import static java.lang.Math.sqrt;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class PrimeAncestorsDescendants {

	public static void main(String[] args) {
		print(100);
	}

	public static void print(int limit) {
		print(get(limit));
	}

	record PAD (int limit, List<List<Integer>> ancestors, List<List<Long>> descendants, int totalDescendants) {}

	public static PAD get(int limit) {
		List<List<Integer>> ancestors = new ArrayList<>(limit);
		List<List<Long>> descendants = new ArrayList<>(limit);
		for (int i=0; i<limit; i+=1) {
			ancestors.add(new ArrayList<>());
			descendants.add(new ArrayList<>());
		}
		
		List<Integer> primes = primesBelow(limit);
		for (int p: primes) {
			descendants.get(p).add((long) p);
			for (int i=0, s=p; s<limit; s+=1, i+=1) {
				for (long d: descendants.get(i)) {
					descendants.get(s).add(p*d);
				}
			}
		}
		
		descendants.get(4).remove(0);
		for (int p: primes) removeLast(descendants.get(p));
		
		int totalDescendants = 0;
		for (int i=1; i<limit; i+=1) {
			List<Long> desc = sort(descendants.get(i));
			totalDescendants += desc.size();
			for (long d: desc) {
				if (d >= limit) break;
				ancestors.set((int) d, add(ancestors.get(i), i));
			}
		}
		
		return new PAD(limit, ancestors, descendants, totalDescendants);
	}

	private static List<Integer> primesBelow(int limit) {
		List<Integer> primes = new ArrayList<>();
		boolean[] isComposite = new boolean[limit];
		//int p=2; for (; p*p<limit; p+=1) {
		int p=2; for (int sr=(int) sqrt(limit); p<sr; p+=1) {
			if (isComposite[p]) continue;
			primes.add(p);
			for (int i=p*p; i<limit; i+=p) isComposite[i] = true;
		}
		for (; p<limit; p+=1) {
			if (isComposite[p]) continue;
			primes.add(p);
		}
		return primes;
	}

	private static List<Long> removeLast(List<Long> list) {
		int size = list.size();
		if (size > 0) list.remove(size-1);
		return list;
	}
	
	private static <T extends Comparable<? super T>> List<T> sort(List<T> list) {
		Collections.sort(list);
		return list;
	}

	private static List<Integer> add(List<Integer> list, int n) {
		list = new ArrayList<>(list);
		list.add(n);
		return list;
	}
	
	public static void print(PAD pad) {
		for (int i=1; i<pad.limit; i+=1) {
			if (i > 20 && i != 46 && i != 74 && i != 94 && i != 99)	continue;
			System.out.printf("%2d:", i);
			printf(" %,d ancestors %-17s", pad.ancestors.get(i));
			printf(" %,6d descendants %s\n", pad.descendants.get(i));
		}
		System.out.printf("\nTotal descendants: %,d\n",  pad.totalDescendants);
	}
	
	private static <T extends Number> void printf(String fmt, List<T> list) {
		System.out.printf(fmt, list.size(), format(list));
	}
	
	private static <T extends Number> String format(List<T> list) {
		if (list.isEmpty()) return "";
		StringBuilder sb = new StringBuilder("[");
		if (list.size() <= 10) {
			for (int i=0; i<list.size(); i+=1) sb.append(format(list, i));
		}
		else {
			for (int i=0; i<5; i+=1) sb.append(format(list, i));
			sb.append(", ...");
			for (int i=list.size()-3; i<list.size(); i+=1) sb.append(format(list, i));
		}
		return sb.append("]").toString();
	}

	private static <T extends Number> String format(List<T> list, int i) {
		return (i==0 ? "" : ", ") + String.format("%,d", list.get(i).longValue());
	}
}
