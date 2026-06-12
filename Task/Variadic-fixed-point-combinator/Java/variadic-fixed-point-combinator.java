import java.util.List;

public final class VariadicFixedPointCombinator {	
	
	public interface CompletedFunction {
		boolean f(int x);
	}
	
	public interface FunctionFixed {
		CompletedFunction g();
	}
	
	public interface FunctionToBeFixed {
		CompletedFunction h(List<FunctionFixed> functionFixed);
		
		static List<FunctionFixed> k(List<FunctionToBeFixed> functionToBeFixed) {
			return List.of( () -> functionToBeFixed.get(0).h(k(functionToBeFixed)),
							() -> functionToBeFixed.get(1).h(k(functionToBeFixed)) );
		}
	}

	public static void main(String[] args) {
		List<FunctionToBeFixed> evenOddFix = List.of(
			functions -> n -> n == 0 ? true : functions.get(1).g().f(n - 1),
			functions -> n -> n == 0 ? false : functions.get(0).g().f(n - 1)
	    );
		
	    List<FunctionFixed> evenOdd = FunctionToBeFixed.k(evenOddFix);
	
	    CompletedFunction even = evenOdd.get(0).g();
	    CompletedFunction odd = evenOdd.get(1).g();
	
	    for ( int i = 0; i <= 9; i++ ) {
	    	System.out.println(i + ": Even: " + even.f(i) + ", Odd: " + odd.f(i));
	    }
	}
}
