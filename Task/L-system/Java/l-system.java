import java.util.List;

public final class LSystem {

	public static void main(String[] args) {		
		String axiom = "A";
		List<Rule> rules = List.of( new Rule("A", "AB"), new Rule("B", "A") );
		final int iterations = 7;
		
		System.out.println(lindenmayer(axiom, rules, iterations));
	}
	
	private static String lindenmayer(String axiom, List<Rule> rules, int iterations) {
		String result = axiom;
		for ( int i = 0; i < iterations; i++ ) {
	        StringBuilder builder = new StringBuilder();
	        for ( String letter : result.split("") ) {
	            for ( Rule rule : rules ) {
	            	if ( letter.equals(rule.source) ) {
	            		builder.append(rule.target);
	            	}
	            }
		 	}
	        result = builder.toString();
		}
	    return result;
	}
	
	private static record Rule(String source, String target) {}

}
