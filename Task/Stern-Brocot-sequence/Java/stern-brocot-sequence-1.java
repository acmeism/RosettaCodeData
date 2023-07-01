import java.math.BigInteger;
import java.util.LinkedList;

public class SternBrocot {
	static LinkedList<Integer> sequence = new LinkedList<Integer>(){{
		add(1); add(1);
	}};
	
	private static void genSeq(int n){
		for(int conIdx = 1; sequence.size() < n; conIdx++){
			int consider = sequence.get(conIdx);
			int pre = sequence.get(conIdx - 1);
			sequence.add(consider + pre);
			sequence.add(consider);
		}
		
	}
	
	public static void main(String[] args){
		genSeq(1200);
		System.out.println("The first 15 elements are: " + sequence.subList(0, 15));
		for(int i = 1; i <= 10; i++){
			System.out.println("First occurrence of " + i + " is at " + (sequence.indexOf(i) + 1));
		}
		
		System.out.println("First occurrence of 100 is at " + (sequence.indexOf(100) + 1));
		
		boolean failure = false;
		for(int i = 0; i < 999; i++){
			failure |= !BigInteger.valueOf(sequence.get(i)).gcd(BigInteger.valueOf(sequence.get(i + 1))).equals(BigInteger.ONE);
		}
		System.out.println("All GCDs are" + (failure ? " not" : "") + " 1");
	}
}
