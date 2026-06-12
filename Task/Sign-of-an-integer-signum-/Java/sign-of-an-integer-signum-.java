import java.util.List;

public final class SignOfAnInteger {

	public static void main(String[] args) {
		List<Integer> integers = List.of( 42, 0, -0, -42 );
		integers.forEach( i-> System.out.println(i + " has signum value " + Integer.signum(i)) );
		System.out.println();
		
		List<Float> floats = List.of( 12.34F, 0.0F, -0.0F, -12.34F );
		floats.forEach( f -> System.out.println(f + " has signum vaue " + Math.signum(f)) );
	}

}
