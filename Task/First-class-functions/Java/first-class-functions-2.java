import java.util.ArrayList;
import java.util.function.Function;

public class FirstClass{
	
	public static void main(String... arguments){
		ArrayList<Function<Double, Double>> functions = new ArrayList<>();
		
		functions.add(Math::cos);
		functions.add(Math::tan);
		functions.add(x -> x * x);
		
		ArrayList<Function<Double, Double>> inverse = new ArrayList<>();
		
		inverse.add(Math::acos);
		inverse.add(Math::atan);
		inverse.add(Math::sqrt);
		System.out.println("Compositions:");
		for (int i = 0; i < functions.size(); i++){
			System.out.println(functions.get(i).compose(inverse.get(i)).apply(0.5));
		}
		System.out.println("Hard-coded compositions:");
		System.out.println(Math.cos(Math.acos(0.5)));
		System.out.println(Math.tan(Math.atan(0.5)));
		System.out.println(Math.pow(Math.sqrt(0.5), 2));
	}
}
