import java.util.ArrayList;

public class FirstClass{
	
	public interface Function<A,B>{
		B apply(A x);
	}
	
	public static <A,B,C> Function<A, C> compose(
			final Function<B, C> f, final Function<A, B> g) {
		return new Function<A, C>() {
			@Override public C apply(A x) {
				return f.apply(g.apply(x));
			}
		};
	}
	
	public static void main(String[] args){
		ArrayList<Function<Double, Double>> functions =
			new ArrayList<Function<Double,Double>>();
		
		functions.add(
				new Function<Double, Double>(){
					@Override public Double apply(Double x){
						return Math.cos(x);
					}
				});
		functions.add(
				new Function<Double, Double>(){
					@Override public Double apply(Double x){
						return Math.tan(x);
					}
				});
		functions.add(
				new Function<Double, Double>(){
					@Override public Double apply(Double x){
						return x * x;
					}
				});
		
		ArrayList<Function<Double, Double>> inverse = new ArrayList<Function<Double,Double>>();
		
		inverse.add(
				new Function<Double, Double>(){
					@Override public Double apply(Double x){
						return Math.acos(x);
					}
				});
		inverse.add(
				new Function<Double, Double>(){
					@Override public Double apply(Double x){
						return Math.atan(x);
					}
				});
		inverse.add(
				new Function<Double, Double>(){
					@Override public Double apply(Double x){
						return Math.sqrt(x);
					}
				});
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
