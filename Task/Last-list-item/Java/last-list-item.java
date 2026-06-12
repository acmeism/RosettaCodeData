import java.util.ArrayList;
import java.util.List;

public final class LastListItem {

	public static void main(String[] args) {
		List<Integer> numbers = new ArrayList<Integer>(List.of( 6, 81, 243, 14, 25, 49, 123, 69, 11 ) );
		
		while ( numbers.size() > 1 ) {
			System.out.print(numbers);
	        final int minValueFirst = numbers.stream().mapToInt( i -> i ).min().getAsInt();
	        numbers.removeIf( i -> i == minValueFirst );
	        final int minValueSecond = numbers.stream().mapToInt( i -> i ).min().getAsInt();
	        numbers.removeIf( i -> i == minValueSecond );
	        final int sum = minValueFirst + minValueSecond;
	        numbers.addLast(sum);
	        System.out.println("  =>  " + minValueFirst + " + " + minValueSecond + " = " + sum);
		}
		System.out.println(numbers);
	}

}
