import java.util.List;
import java.util.stream.IntStream;

public final class Base16NumbersNeedingAToF {

	public static void main(String[] args) {
		List<Integer> needsAtoF = IntStream.range(0, 501)
			.filter( i -> Integer.toHexString(i).chars()
				.anyMatch( ch -> "abcdef".contains(String.valueOf((char) ch))) )
			.boxed().toList();
		
		for ( int i = 0; i < needsAtoF.size(); i++ ) {
			System.out.print(String.format("%3d%s",
				needsAtoF.get(i), ( i % 19 == 18 ? "\n" : " " )));
		}
		System.out.println();
	}
	
}
