import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class PancakeNumbers {

	public static void main(String[] args) {
		for ( int n = 1; n <= 9; n++ ) {
			PancakeInfo result = pancake(n);
			System.out.println(String.format("%s%2d%s", "Pancake(", result.index, "). Example " + result.pancake));
		}
	}
	
	private static PancakeInfo pancake(int number) {
		List<Integer> initialStack = IntStream.rangeClosed(1, number).boxed().collect(Collectors.toList());
		Map<List<Integer>, Integer> stackFlips = new HashMap<List<Integer>, Integer>();
		stackFlips.put(initialStack, 0);
		Queue<List<Integer>> queue = new ArrayDeque<List<Integer>>();
		queue.add(initialStack);
		
		while ( ! queue.isEmpty() ) {
			List<Integer> stack = queue.remove();

			final int flipCount = stackFlips.get(stack) + 1;
			for ( int i = 2; i <= number; i++ ) {
				List<Integer> flipped = flipStack(stack, i);
				if ( stackFlips.putIfAbsent(flipped, flipCount) == null ) {
					queue.add(flipped);
				}
			}			
	    }
		
		Map.Entry<List<Integer>, Integer> entry =
			stackFlips.entrySet().stream().max(Comparator.comparing( e -> e.getValue() )).get();		
		return new PancakeInfo(entry.getKey(), entry.getValue());
	}
	
	private static List<Integer> flipStack(List<Integer> stack, int index) {
        List<Integer> copy = new ArrayList<Integer>(stack);
        Collections.reverse(copy.subList(0, index));
        return copy;
    }
	
	private static record PancakeInfo(List<Integer> pancake, int index) {}

}
