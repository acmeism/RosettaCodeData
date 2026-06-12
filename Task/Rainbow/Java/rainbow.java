import java.util.List;

public final class Rainbow {

	 public static void main(String[] args) {
	    	// ANSI escape code constants for foreground text colours
	        final String RED =    "\u001B[38;2;255;0;0m";
	        final String ORANGE = "\u001B[38;2;255;128;0m";
	        final String YELLOW = "\u001B[38;2;255;255;0m";
	        final String GREEN =  "\u001B[38;2;0;255;0m";
	        final String BLUE =   "\u001B[38;2;0;0;255m";
	        final String INDIGO = "\u001B[38;2;75;0;130m";
	        final String VIOLET = "\u001B[38;2;128;0;255m";
	
	        // ANSI escape code constant to reset the terminal to its default values
	        final String RESET = "\u001B[0m";
	
	        List<String> colours = List.of( RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET );
	
	        String rainbow = "RAINBOW";
	
	        for ( int i = 0; i < 7; i++ ) {
	        	System.out.print(colours.get(i) + rainbow.charAt(i));
	        }
	        System.out.println(RESET);
	    }

}
