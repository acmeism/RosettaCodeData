import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

public class TruthTable {
    public static void main( final String... args ) {
        System.out.println( new TruthTable( args ) );
    }

    private interface Operator {
        boolean evaluate( Stack<Boolean> s );
    }

    /**
     * Supported operators and what they do. For more ops, add entries here.
     */
    private static final Map<String,Operator> operators = new HashMap<String,Operator>() {{
        // Can't use && or || because shortcut evaluation may mean the stack is not popped enough
        put( "&", stack -> Boolean.logicalAnd( stack.pop(), stack.pop() ) );
        put( "|", stack -> Boolean.logicalOr( stack.pop(), stack.pop() ) );
        put( "!", stack -> ! stack.pop() );
        put( "^", stack -> ! stack.pop().equals ( stack.pop() ) );
    }};

    private final List<String> variables;
    private final String[]     symbols;

    /**
     * Constructs a truth table for the symbols in an expression.
     */
    public TruthTable( final String... symbols ) {
        final Set<String> variables = new LinkedHashSet<>();

        for ( final String symbol : symbols ) {
            if ( ! operators.containsKey( symbol ) ) {
                variables.add( symbol );
            }
        }
        this.variables = new ArrayList<>( variables );
        this.symbols = symbols;
    }

    @Override
    public String toString () {
        final StringBuilder result = new StringBuilder();

        for ( final String variable : variables ) {
            result.append( variable ).append( ' ' );
        }
        result.append( ' ' );
        for ( final String symbol : symbols ) {
            result.append( symbol ).append ( ' ' );
        }
        result.append( '\n' );
        for ( final List<Boolean> values : enumerate( variables.size () ) ) {
            final Iterator<String> i = variables.iterator();

            for ( final Boolean value : values ) {
                result.append(
                    String.format(
                        "%-" + i.next().length() + "c ",
                        value ? 'T' : 'F'
                    )
                );
            }
            result.append( ' ' )
                .append( evaluate( values ) ? 'T' : 'F' )
                .append( '\n' );
        }

        return result.toString ();
    }

    /**
     * Recursively generates T/F values
     */
    private static List<List<Boolean>> enumerate( final int size ) {
        if ( 1 == size )
            return new ArrayList<List<Boolean>>() {{
                add( new ArrayList<Boolean>() {{ add(false); }} );
                add( new ArrayList<Boolean>() {{ add(true);  }} );
            }};

        return new ArrayList<List<Boolean>>() {{
            for ( final List<Boolean> head : enumerate( size - 1 ) ) {
                add( new ArrayList<Boolean>( head ) {{ add(false); }} );
                add( new ArrayList<Boolean>( head ) {{ add(true);  }} );
            }
        }};
    }

    /**
     * Evaluates the expression for a set of values.
     */
    private boolean evaluate( final List<Boolean> enumeration ) {
        final Iterator<Boolean>   i      = enumeration.iterator();
        final Map<String,Boolean> values = new HashMap<>();
        final Stack<Boolean>      stack  = new Stack<>();

        variables.forEach ( v -> values.put( v, i.next() ) );
        for ( final String symbol : symbols ) {
            final Operator op = operators.get ( symbol );

            // Reverse Polish notation makes this bit easy
            stack.push(
                null == op
                    ? values.get ( symbol )
                    : op.evaluate ( stack )
            );
        }
        return stack.pop();
    }
}
