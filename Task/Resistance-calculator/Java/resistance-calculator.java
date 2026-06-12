import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Stack;

public final class ResistanceCalculator {

	public static void main(String[] args) {
		rpnSyntax("RPN syntax:", "10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +", 18.0);
		System.out.println();
	
		infixSyntax("Infix syntax:", "((((10 + 2) * 6 + 8) * 6 + 4) * 8 + 4) * 8 + 6", 18.0);	
	}
	
	private static void rpnSyntax(String title, String rpn, double voltage) {
		System.out.println(title);
		Resistor root = build(rpn);
		System.out.println("    Ohm    Volt   Ampere   Watt  Network tree");
		root.setVoltage(voltage);
		root.report();
	}
	
	private static void infixSyntax(String title, String infix, double voltage) {
		rpnSyntax(title, convertToRPN(infix), voltage);
	}
	
	private static Resistor build(String text) {
		Stack<Resistor> stack = new Stack<Resistor>();
		for ( String word : text.split(" ") ) {
			if ( word.equals("+") ) {
				stack.push( new SerialResistor(stack.pop(), stack.pop()) );
			} else if ( word.equals("*") ) {
				stack.push( new ParallelResistor(stack.pop(), stack.pop()) );
			} else {
				stack.push( new Resistor(Double.valueOf(word)) );
			}
		}
		return stack.pop();
	}
	
	private static String convertToRPN(String text) {
	    final Map<Character, Integer> precedence = Map.ofEntries(
	    	Map.entry('(', 0), Map.entry('+', 1), Map.entry('*', 2) );

	    List<String> items = new ArrayList<String>();
	    Stack<Character> stack = new Stack<Character>();
	    int end = 0;
	    while ( end < text.length() ) {
	        int start = end;
	        final char ch = text.charAt(end);
	        end += 1;
	        switch ( ch ) {
	        	case '(' -> stack.push(ch);
		        case '+', '*' -> {
		        	while ( ! stack.isEmpty() && precedence.get(ch) <= precedence.get(stack.peek()) ) {
		                items.add(String.valueOf(stack.pop()));
		        	}
		            stack.push(ch);
		        }
		        case ')' -> {
		        	while ( stack.peek() != '(' ) {
		                items.add(String.valueOf(stack.pop()));
		            }
		            stack.pop();
		        }
		        default -> {
		        	if ( Character.isDigit(ch) ) {
			            while ( end < text.length() && Character.isDigit(text.charAt(end)) ) {
			                end += 1;
			            }
			            items.add(text.substring(start, end)); // Extract a multi-digit number
			        }
		        }
	        }
	    }
	
	    while ( ! stack.isEmpty() ) {
	    	items.add(String.valueOf(stack.pop()));
	    } 	
	    return String.join(" ", items);
	}

}

class Resistor {
	
	public Resistor(char aSymbol, double aResistance, Resistor aA, Resistor aB) {
		symbol = aSymbol;
		resistance = aResistance;
		a = aA;
		b = aB;
	}
	
	public Resistor(double aResistance) {
		this('r', aResistance, null, null);
	}
	
	protected double getResistance() { return resistance; }
	protected double getVoltage() { return voltage; }
	protected void setVoltage(double aVoltage) { voltage = aVoltage; }
	protected double getCurrent() { return voltage / resistance; }
	protected double getPower() { return getCurrent() * voltage; }
	
	protected void report() { report(""); }
	protected void report(String level) {
		System.out.println(String.format("%8.3f%8.3f%8.3f%8.3f%s %c",
			getResistance(), getVoltage(), getCurrent(), getPower(), level, symbol));
		if ( a != null ) { a.report(level + " | "); }
		if ( b != null ) { b.report(level + " | "); }
	}	
	
	private char symbol;
	private double resistance;
	private double voltage;
	private Resistor a;
	private Resistor b;

}

final class SerialResistor extends Resistor {
	
	public SerialResistor(Resistor aA, Resistor aB) {		
		super('+', 0.0, aB, aA);
		a = aA;
		b = aB;
	}
	
	protected double getResistance() { return a.getResistance() + b.getResistance(); }
	protected double getVoltage() { return voltage; }
	protected void setVoltage(double aVoltage) {
		final double resistanceA = a.getResistance();
		final double resistanceB = b.getResistance();
		a.setVoltage(aVoltage * resistanceA / ( resistanceA + resistanceB ));
		b.setVoltage(aVoltage * resistanceB / ( resistanceA + resistanceB ));
		voltage = aVoltage;
	}
	protected double getCurrent() { return voltage / getResistance(); }
	protected double getPower() { return getCurrent() * voltage; }
	
	private double voltage;
	private Resistor a;
	private Resistor b;
	
}

final class ParallelResistor extends Resistor {
	
	public ParallelResistor(Resistor aA, Resistor aB) {		
		super('*', 0.0, aB, aA);
		a = aA;
		b = aB;
	}
	
	protected double getResistance() { return 1.0 / ( 1.0 / a.getResistance() + 1.0 / b.getResistance() ); }
	protected double getVoltage() { return voltage; }
	protected void setVoltage(double aVoltage) {
		a.setVoltage(aVoltage);
		b.setVoltage(aVoltage);
		voltage = aVoltage;
	}
	protected double getCurrent() { return voltage / getResistance(); }
	protected double getPower() { return getCurrent() * voltage; }
	
	private double voltage;
	private Resistor a;
	private Resistor b;
	
}
