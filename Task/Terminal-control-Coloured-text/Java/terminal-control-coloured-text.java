public class TerminalControlColouredText {

	public static void main(String[] args) {		
		 System.out.print(Color.GREEN_BACKGROUND);
		 System.out.print(Color.WHITE_UNDERLINED);
	     System.out.println("Green background with underlined white text");
	     System.out.println(Color.RESET);

	     System.out.print(Color.YELLOW_BACKGROUND_BRIGHT);
	     System.out.print(Color.BLUE_BOLD);
	     System.out.println("Bright yellow background with bold blue text");
	     System.out.println(Color.RESET);

	     System.out.print(Color.CYAN_BACKGROUND);
	     System.out.print(Color.MAGENTA_BOLD_BRIGHT);
	     System.out.println("Cyan background with bold bright magenta text");
	     System.out.println(Color.RESET);
	}
	
	private enum Color {
		// Restore original background and text colours
	    RESET("\033[0m"),

	    // Text colours
	    BLACK("\033[0;30m"),
	    RED("\033[0;31m"),
	    GREEN("\033[0;32m"),
	    YELLOW("\033[0;33m"),
	    BLUE("\033[0;34m"),
	    MAGENTA("\033[0;35m"),
	    CYAN("\033[0;36m"),
	    WHITE("\033[0;37m"),

	    // Bold text colours
	    BLACK_BOLD("\033[1;30m"),
	    RED_BOLD("\033[1;31m"),
	    GREEN_BOLD("\033[1;32m"),
	    YELLOW_BOLD("\033[1;33m"),
	    BLUE_BOLD("\033[1;34m"),
	    MAGENTA_BOLD("\033[1;35m"),
	    CYAN_BOLD("\033[1;36m"),
	    WHITE_BOLD("\033[1;37m"),

	    // Underlined text colours
	    BLACK_UNDERLINED("\033[4;30m"),
	    RED_UNDERLINED("\033[4;31m"),
	    GREEN_UNDERLINED("\033[4;32m"),
	    YELLOW_UNDERLINED("\033[4;33m"),
	    BLUE_UNDERLINED("\033[4;34m"),
	    MAGENTA_UNDERLINED("\033[4;35m"),
	    CYAN_UNDERLINED("\033[4;36m"),
	    WHITE_UNDERLINED("\033[4;37m"), 	

	    // Bright text colours
	    BLACK_BRIGHT("\033[0;90m"),
	    RED_BRIGHT("\033[0;91m"),
	    GREEN_BRIGHT("\033[0;92m"),
	    YELLOW_BRIGHT("\033[0;93m"),
	    BLUE_BRIGHT("\033[0;94m"),
	    MAGENTA_BRIGHT("\033[0;95m"),
	    CYAN_BRIGHT("\033[0;96m"),
	    WHITE_BRIGHT("\033[0;97m"),
	
	    // Bold and bright text colours
	    BLACK_BOLD_BRIGHT("\033[1;90m"),
	    RED_BOLD_BRIGHT("\033[1;91m"),
	    GREEN_BOLD_BRIGHT("\033[1;92m"),
	    YELLOW_BOLD_BRIGHT("\033[1;93m"),
	    BLUE_BOLD_BRIGHT("\033[1;94m"),
	    MAGENTA_BOLD_BRIGHT("\033[1;95m"),
	    CYAN_BOLD_BRIGHT("\033[1;96m"),
	    WHITE_BOLD_BRIGHT("\033[1;97m"),
	
	    // Background colours
	    BLACK_BACKGROUND("\033[40m"),
	    RED_BACKGROUND("\033[41m"),
	    GREEN_BACKGROUND("\033[42m"),
	    YELLOW_BACKGROUND("\033[43m"),
	    BLUE_BACKGROUND("\033[44m"),
	    MAGENTA_BACKGROUND("\033[45m"),
	    CYAN_BACKGROUND("\033[46m"),
	    WHITE_BACKGROUND("\033[47m"),

	    // Bright background colours
	    BLACK_BACKGROUND_BRIGHT("\033[0;100m"),
	    RED_BACKGROUND_BRIGHT("\033[0;101m"),
	    GREEN_BACKGROUND_BRIGHT("\033[0;102m"),
	    YELLOW_BACKGROUND_BRIGHT("\033[0;103m"),
	    BLUE_BACKGROUND_BRIGHT("\033[0;104m"),
	    MAGENTA_BACKGROUND_BRIGHT("\033[0;105m"),
	    CYAN_BACKGROUND_BRIGHT("\033[0;106m"),
	    WHITE_BACKGROUND_BRIGHT("\033[0;107m");    	

	    private Color(String aCode) {
	        code = aCode;
	    }

	    @Override
	    public String toString() {
	        return code;
	    }
	
	    private final String code;
	
	}

}
