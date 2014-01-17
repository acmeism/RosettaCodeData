import java.util.Stack;

public class StackTest {
    public static void main( final String[] args ) {
        final Stack<String> stack = new Stack<String>();

        System.out.println( "New stack empty? " + stack.empty() );

        stack.push( "There can be only one" );
        System.out.println( "Pushed stack empty? " + stack.empty() );
        System.out.println( "Popped single entry: " + stack.pop() );

        stack.push( "First" );
        stack.push( "Second" );
        System.out.println( "Popped entry should be second: " + stack.pop() );

        // Popping an empty stack will throw...
        stack.pop();
        stack.pop();
    }
}
