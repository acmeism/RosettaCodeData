import java.util.List;

public final class CamelCaseAndSnakeCase {

	public static void main(String[] aArgs) {
		List<String> variableNames = List.of( "snakeCase", "snake_case", "variable_10_case", "variable10Case",
			"ergo rE tHis", "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  ");
		
		System.out.println(String.format("%48s", "=== To snake_case ==="));
		for ( String text : variableNames ) {
			System.out.println(String.format("%34s%s%s", text, " --> ", toSnakeCase(text)));
		}

		System.out.println();
		System.out.println(String.format("%48s", "=== To camelCase ==="));
		for ( String text : variableNames ) {
			System.out.println(String.format("%34s%s%s", text, " --> ", toCamelCase(text)));
		}
	}	
	
	private static String toSnakeCase(String aCamel) {
		aCamel = aCamel.trim().replace(SPACE, UNDERSCORE).replace(HYPHEN, UNDERSCORE);
	    StringBuilder snake = new StringBuilder();
	    boolean first = true;
	    for ( char ch : aCamel.toCharArray() ) {
	        if ( first ) {
	            snake.append(ch);
	            first = false;
	        } else if ( ! first && Character.isUpperCase(ch) ) {
	            if ( snake.toString().endsWith(UNDERSCORE) ) {
	                snake.append(Character.toLowerCase(ch));
	            } else {
	                snake.append(UNDERSCORE + Character.toLowerCase(ch));
	            }
	        } else {
	            snake.append(ch);
	        }
	    }
	    return snake.toString();
		
	}
	
	private static String toCamelCase(String aSnake) {
		aSnake = aSnake.trim().replace(SPACE, UNDERSCORE).replace(HYPHEN, UNDERSCORE);
	    StringBuilder camel = new StringBuilder();
	    boolean underscore = false;
	    for ( char ch : aSnake.toCharArray() ) {
	        if ( Character.toString(ch).equals(UNDERSCORE) ) {
	            underscore = true;
	        } else if ( underscore ) {
	            camel.append(Character.toUpperCase(ch));
	            underscore = false;
	        } else {
	            camel.append(ch);
	        }
	    }
	    return camel.toString();		
	}
	
	private static final String SPACE = " ";
	private static final String UNDERSCORE = "_";
	private static final String HYPHEN = "-";
	
}
