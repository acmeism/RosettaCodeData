import java.util.ArrayList;
import java.util.function.Function;

public class FirstClass{
	
	public static <A,B,C> Function<A, C> compose(
			final Function<B, C> f, final Function<A, B> g) {
		return new Function<A, C>() {
			@Override public C apply(A x) {
				return f.apply(g.apply(x));
			}
		};
	}
	
	public static void main(String[] args){
		ArrayList<Function<Double, Double>> functions = new ArrayList<>();
		
		functions.add(Math::cos);
		functions.add(Math::tan);
		functions.add(x -> x * x);
		
		ArrayList<Function<Double, Double>> inverse = new ArrayList<>();
		
		inverse.add(Math::acos);
		inverse.add(Math::atan);
		inverse.add(Math::sqrt);
		System.out.println("Compositions:");
		for(int i = 0; i < functions.size(); i++){
			System.out.println(compose(functions.get(i), inverse.get(i)).apply(0.5));
		}
		System.out.println("Hard-coded compositions:");
		System.out.println(Math.cos(Math.acos(0.5)));
		System.out.println(Math.tan(Math.atan(0.5)));
		System.out.println(Math.pow(Math.sqrt(0.5), 2));
	}
}
