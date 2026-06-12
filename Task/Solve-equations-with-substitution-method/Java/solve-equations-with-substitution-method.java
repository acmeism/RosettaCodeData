import java.util.List;

public final class SolveEquationsWithSubstitutionMethod {

	public static void main(String[] args) {
		List<Double> eqn1 = List.of( 3.0, 1.0, -1.0 );   // 3x + y = -1
		List<Double> eqn2 = List.of( 2.0, -3.0, -19.0 ); // 2x - 3y = -19
		
		final double y = ( ( eqn1.get(0) * eqn2.get(2) ) - ( eqn2.get(0) * eqn1.get(2) ) )
			/ ( ( eqn2.get(0) * -eqn1.get(1) ) + ( eqn1.get(0) * eqn2.get(1) ) );
		final double x = ( eqn1.get(2) - ( eqn1.get(1) * y ) ) / eqn1.get(0);
		
		System.out.println("x = %.3f, y = %.3f".formatted(x, y));
	}

}
