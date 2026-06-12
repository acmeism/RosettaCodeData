import module java.base;

public final class CompilerVerifyingSyntax {

	public static void main() {
		// Using the tests from the Algol68 example
		List<String> tests = List.of(
		    "wombat",
		    "wombat or monotreme",
		    "( wombat and not )",
		    "wombat or not",
		    "a + 1",
		    "a + b < c",
		    "a + b - c * d / e < f and not ( g = h )",
		    "a + b - c * d / e < f and not ( g = h",
		    "a = b",
		    "a or b = c",
		    "$",
		    "true or false = not true",
		    "not true = false",
		    "3 + not 5",
		    "3 + (not 5)",
		    "(42 + 3",
		    " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
		    " and 3 < 2",
		    "not 7 < 2",
		    "2 < 3 < 4",
		    "2 < foobar - 3 < 4",
		    "2 < foobar and 3 < 4",
		    "4 * (32 - 16) + 9 = 73",
		    "235 76 + 1",
		    "a + b = not c and false",
		    "a + b = (not c) and false",
		    "a + b = (not c and false)",
		    "ab_c / bd2 or < e_f7",
		    "g not = h",
		    "été = false",
		    "i++",
		    "j & k",
		    "l or _m"
		);
		
		tests.forEach( test -> {
			Lexer lexer = new Lexer(test);
			final boolean ok = lexer.checkStatement();
			IO.println("\"%s\" -> %b".formatted(test, ok));
			IO.println(ok ? "" : "Error at index %d. %s%n".formatted(lexer.position - 1, lexer.errorMessage));
		} );
	}
	
	private static final class Lexer {
	
	    public Lexer(String aText) {
	        text = aText;
	        textLength = text.length();

	        nextToken();
	    }	
	
	    public boolean checkStatement() {
	        boolean result = checkExpression();
	        if ( result && position < textLength ) {
	            errorMessage = "Extra characters at end of statement.";
	            result = false;
	        }
	
	        return result;
	    }	
	
	    private void getIdentifierToken() {
	        StringBuilder builder = new StringBuilder();
	        while ( position < textLength && isIdentifierChar.test(text.charAt(position))) {	        	
	        	builder.append(text.charAt(position));
	        	position += 1;
	        }
	
	        String str = builder.toString();
	        token = booleans.contains(str) ? Token.valueOf(str.toUpperCase()) : Token.IDENTIFIER;
	    }
	
	    private void getIntToken() {
	        while ( position < textLength && Character.isDigit(text.charAt(position)) ) {
	        	position += 1;
	        }
	
	        token = Token.INT;
	    }
	
	    private void nextToken() {
	        while ( position < textLength && text.charAt(position) == ' ' ) {
	        	position += 1;
	        }
	        	
	        if ( position == textLength ) {
	            token = Token.EOF;
	        } else {
	            final char ch = text.charAt(position);
	            if ( isASCIILowerCase.test(ch) ) {
	                getIdentifierToken();
	            } else if ( Character.isDigit(ch) ) {
	                getIntToken();
	            } else {
	                position += 1;
	                String str = "%c".formatted(ch);
	                token = symbols.contains(str) ? Token.fromText(str) : Token.ERROR;
	            }
	        }
	    }
	    	
	    private boolean primaryExpressionCheck() {
	        if ( List.of( Token.IDENTIFIER, Token.INT, Token.FALSE, Token.TRUE ).contains(token) ) {
	            nextToken();
	            return true;
	        } else if ( token == Token.LEFT_PAREN ) {
	            nextToken();
	            if ( ! checkExpression() ) {
	            	return false;
	            }
	
	            if ( token != Token.RIGHT_PAREN ) {
	            	errorMessage = "Encountered %s; expected ')'.".formatted(addQuotationMarks(token.getText()));
	                return false;
	            } else {
	                nextToken();
	                return true;
	            }
	        } else {
	        	errorMessage = "Encountered %s; expected identifier, literal or '('."
	        		.formatted(addQuotationMarks(token.getText()));
	            return false;
	        }
	    }	
	
	    private boolean checkExpression4() {
	        if ( ! primaryExpressionCheck() ) {
	        	return false;
	        }
	
	        while ( List.of( Token.MUL, Token.DIV ).contains(token) ) {
	            nextToken();
	            if ( ! primaryExpressionCheck() ) {
	            	return false;
	            }
	        }
	
	        return true;
	    }
	
	    private boolean checkExpression3() {
	        if ( ! checkExpression4() ) {
	        	return false;
	        }
	
	        while ( List.of( Token.ADD, Token.SUB ).contains(token) ) {
	            nextToken();
	            if ( ! checkExpression4() ) {
	            	return false;
	            }
	        }
	
	        return true;
	    }
	
	    private boolean checkExpression2() {
	        if ( token == Token.NOT ) {
	        	nextToken();
	        }
	
	        if ( ! checkExpression3() ) {
	        	return false;
	        }
	
	        if ( List.of( Token.LT, Token.EQ ).contains(token) ) {
	            nextToken();
	            if ( ! checkExpression3() ) {
	            	return false;
	            }
	        }
	
	        return true;
	    }
	
	    private boolean checkExpression1() {
	        if ( ! checkExpression2() ) {
	        	return false;
	        }
	
	        while ( token == Token.AND ) {
	            nextToken();
	            if ( ! checkExpression2() ) {
	            	return false;
	            }
	        }
	
	        return true;
	    }
	
	    private boolean checkExpression() {
	        if ( ! checkExpression1() ) {
	        	return false;
	        }
	
	        while ( token == Token.OR ) {
	            nextToken();
	            if ( ! checkExpression1() ) {
	            	return false;
	            }
	        }
	
	        return true;
	    }
	
	    private String addQuotationMarks(String str) {
	    	return ( booleans.contains(str) || symbols.contains(str) ) ? "'%s'".formatted(str) : str;
	    }
	
	    private String errorMessage;
	    private int position;
	    private Token token;
	
	    private final String text;
	    private final int textLength;
	
	}
	
	private enum Token {
		
		ERROR("invalid token"), IDENTIFIER("identifier"), INT("integer"), LEFT_PAREN("("), RIGHT_PAREN(")"),
		FALSE("false"), TRUE("true"), LT("<"), EQ("="), ADD("+"), SUB("-"), MUL("*"), DIV("/"),
		OR("or"), AND("and"), NOT("not"), EOF("EOF");
		
		public String getText() {
			return text;
		}
		
		public static Token fromText(String text) {
			for ( Token token : Token.values() ) {
	            if ( token.text.equals(text) ) {
	                return token;
	            }
	        }
			
			throw new IllegalArgumentException("Unknown text: " + text);
	    }
		
		private Token(String aText) {
			text = aText;
		}
		
		private String text;
		
	}
	
	private static Predicate<Character> isASCIILowerCase = ch -> ( ch >= 'a' && ch <= 'z' );
	
	private static Predicate<Character> isIdentifierChar = ch ->
		isASCIILowerCase.test(ch) || ( ch >= '0' && ch <= '9' ) || ch == '_';
	
	private static List<String> booleans = List.of( "false", "true", "or", "and", "not" );
	private static List<String> symbols = List.of( "(", ")", "<", "=", "+", "-", "*", "/" );

}
