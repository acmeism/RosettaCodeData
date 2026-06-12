import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

public final class McNaughtonYamadaThompsonAlgorithm {

	public static void main(String[] args) {
		List<String> infixes = List.of( "a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c" );
	    List<String> strings = List.of( "", "abc", "abbc", "abcc", "abad", "abbbc" );

	    for ( String infix : infixes ) {
	        for ( String string : strings ) {
	            final boolean result = matchRegex(string, infix);
	            System.out.println(( result ? "True " : "False " ) + infix + " " + string);
	        }
	        System.out.println();
	    }

	}
	
	// Match the given string against the given infix regex
	private static boolean matchRegex(String text, String infix) {
	    String postfix = shunt(infix);
	    // Uncomment the next line to see the postfix expression
	    // System.out.println("Postfix: " + postfix);

	    NFA nfa = compileRegex(postfix);

	    Set<State> current = followes(nfa.initial);
	    Set<State> nextStates = new HashSet<State>();

	    for ( char ch : text.toCharArray() ) {
	        for ( State state : current ) {
	            if ( state.label == ch ) {
	                Set<State> follow = followes(state.edge1);
	                nextStates.addAll(follow);
	            }
	        }
	        current = new HashSet<State>(nextStates);
	        nextStates.clear();
	    }

	    return current.contains(nfa.accept);
	}
		
	// Compile the given postfix regex into an NFA
	private static NFA compileRegex(String postfix) {
	    Stack<NFA> nfaStack = new Stack<NFA>();

	    for ( char ch : postfix.toCharArray() ) {
	    	switch ( ch ) {
		    	case '*' -> {
		            NFA nfa1 = nfaStack.pop();
		            State initial = new State();
		            State accept = new State();
		            initial.edge1 = nfa1.initial;
		            initial.edge2 = accept;
		            nfa1.accept.edge1 = nfa1.initial;
		            nfa1.accept.edge2 = accept;
		            nfaStack.push( new NFA(initial, accept) );
		        }
		    	case '.' -> {
		            NFA nfa2 = nfaStack.pop();
		            NFA nfa1 = nfaStack.pop();
		            nfa1.accept.edge1 = nfa2.initial;
		            nfaStack.push( new NFA(nfa1.initial, nfa2.accept) );
		        }
		    	case '|' -> {
		            NFA nfa2 = nfaStack.pop();
		            NFA nfa1 = nfaStack.pop();
		            State initial = new State();
		            State accept = new State();
		            initial.edge1 = nfa1.initial;
		            initial.edge2 = nfa2.initial;
		            nfa1.accept.edge1 = accept;
		            nfa2.accept.edge1 = accept;
		            nfaStack.push( new NFA(initial, accept) );
		        }
		    	case '+' -> {
		            NFA nfa1 = nfaStack.pop();
		            State initial = new State();
		            State accept = new State();
		            initial.edge1 = nfa1.initial;
		            nfa1.accept.edge1 = nfa1.initial;
		            nfa1.accept.edge2 = accept;
		            nfaStack.push( new NFA(initial, accept) );
		        }
		    	case '?' -> {
		            NFA nfa1 = nfaStack.pop();
		            State initial = new State();
		            State accept = new State();
		            initial.edge1 = nfa1.initial;
		            initial.edge2 = accept;
		            nfa1.accept.edge1 = accept;
		            nfaStack.push( new NFA(initial, accept) );
		        }
		    	default -> { // Literal character
		            State initial = new State(ch);
		            State accept = new State();
		            initial.edge1 = accept;
		            nfaStack.push( new NFA(initial, accept) );
		        }
	    	}	
	    }
	
	    return nfaStack.peek(); 	
	}
	
	// Compute the epsilon closure of the given state
	private static Set<State> followes(State state) {
	    Set<State> states = new HashSet<State>();
	    Stack<State> stack = new Stack<State>();
	    stack.push(state);

	    while ( ! stack.isEmpty() ) {
	        State current = stack.pop();
	        if ( ! states.contains(current) ) {
	            states.add(current);
	            if ( current.label == '\0' ) { // Epsilon transition
	                if ( current.edge1 != null ) {
	                    stack.push(current.edge1);
	                }
	                if ( current.edge2 != null ) {
	                    stack.push(current.edge2);
	                }
	            }
	        }
	    }

	    return states;
	}
		
	// Convert the given infix regex to postfix regex using the Shunting Yard algorithm
	private static String shunt(String infix) {
	    Map<Character, Integer> specials = Map.ofEntries( Map.entry( '*', 60 ), Map.entry( '+', 55 ),
	    						    Map.entry( '?', 50 ), Map.entry( '.', 40 ), Map.entry( '|', 20 ) );	
	
	    Stack<Character> stack = new Stack<Character>();
	    String postfix = "";

	    for ( char ch : infix.toCharArray() ) {
	        if ( ch == '(' ) {
	            stack.push(ch);
	        }
	        else if ( ch == ')' ) {
	            while ( ! stack.isEmpty() && stack.peek() != '(' ) {
	                postfix += stack.pop();
	            }
	            if ( ! stack.isEmpty() ) {
	                stack.pop(); // Remove '('
	            }
	        }
	        else if ( specials.containsKey(ch) ) {
	            while ( ! stack.isEmpty() && specials.containsKey(stack.peek()) &&
	            	specials.get(ch) <= specials.get(stack.peek()) ) {
	                postfix += stack.pop();
	            }
	            stack.push(ch);
	        }
	        else {
	            postfix += ch;
	        }	
	    }
	
	    while ( ! stack.isEmpty() ) {
	        postfix += stack.pop();
	    }

	    return postfix;
	}
	
	private static final class State {
		
		public State(char aLabel) {
			label = aLabel;
		}
		
		public State() {
			label = '\0';
		}
	
	    private State edge1 = null; // First transition
	    private State edge2 = null; // Second transition
	
	    private final char label;   // Character label, '\0' for epsilon
	
	}
	
	private static final class NFA {
		
		public NFA(State aInitial, State aAccept) {
			initial = aInitial;
			accept = aAccept;
		}
		
	    private State initial;
	    private State accept;
	
	}

}
