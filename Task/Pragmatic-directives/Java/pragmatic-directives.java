import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class PragmaticDirectives {
	
	public static void main(String[] aArgs) {		
		/* Take no action */
	}
	
	@FunctionalInterface
	public interface Adder {   			 // This annotation indicates a functional interface,
	    abstract int add(int a, int b);  // which has exactly one abstract method.
	}
	
	@Deprecated
    public void Display() {
        System.out.println("This author is indicating that this method is deprecated");
    }
	
	@SuppressWarnings("unchecked")
	public void uncheckedWarning() {
	    List words = new ArrayList();
	    words.add("hello");
	    System.out.println("THe compiler is warning that the generic type declaration is missing.");
	    System.out.println("The correct syntax is: List<String> words = new ArrayList<String>()");
	}
	
	@SafeVarargs
	public static <T> List<T> list(final T... items) {
		System.out.println("This annotation suppresses unchecked warnings about a non-reifiable variable arity type");
	    return Arrays.asList(items);
	}
	
}
