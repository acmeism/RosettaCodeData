public class TreeDatastructures {

	public static void main(String[] args) {
		String initialNested = """
	    Rosetta Code
	    ....rocks
	    ........code
	    ........comparison
	    ........wiki
	    ....mocks
	    ........trolling
	    """;
	
	    System.out.println(initialNested);
	
	    String indented = nestedToIndented(initialNested);
	    System.out.println(indented);
	
	    String finalNested = indentedToNested(indented);
	    System.out.println(finalNested);

	    final boolean equal = ( initialNested.compareTo(finalNested) == 0 );
	    System.out.println("initialNested = finalNested ? " + equal);
	}	
	
	private static String nestedToIndented(String nested) {
		StringBuilder result = new StringBuilder();
	
		for ( String line : nested.split(LINE_END) ) {
			int index = 0;
			while ( line.charAt(index) == '.' ) {
				index += 1;
			}						
			result.append(String.valueOf(index / 4) + " " + line.substring(index) + LINE_END);			
		}
		
		return result.toString();
	}	

	private static String indentedToNested(String indented) {
		StringBuilder result = new StringBuilder();
		
		for ( String line : indented.split(LINE_END) ) {
			final int index = line.indexOf(' ');
			final int level = Integer.valueOf(line.substring(0, index));			
			for ( int i = 0; i < level; i++ ) {
				result.append("....");
			}
			result.append(line.substring(index + 1) + LINE_END);
		}		
		
		return result.toString();
	}
	
	private static final String LINE_END = "\n";

}
