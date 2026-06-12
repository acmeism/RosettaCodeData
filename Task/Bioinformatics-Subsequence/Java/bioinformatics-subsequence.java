import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class BioinformaticsSubsequence {

	public static void main(String[] args) {
		List<String> bases = List.of( "A", "C", "G", "T" );
		ThreadLocalRandom random = ThreadLocalRandom.current();
		
		String dna = random.ints(200, 0, 4).mapToObj( i-> bases.get(i) ).collect(Collectors.joining());
		String subsequence = random.ints(4, 0, 4).mapToObj( i-> bases.get(i) ).collect(Collectors.joining());
		System.out.println("DNA sequence:");		
		System.out.println(dna);
		System.out.println("Subsequence to locate: " + subsequence);
		
		List<Integer> indexes = IntStream
			.iterate(dna.indexOf(subsequence), index -> index >= 0, index -> dna.indexOf(subsequence, index + 1))
		    .boxed().toList();
		
		System.out.println("Matches found starting at the following indexes: " + indexes);
	}

}
