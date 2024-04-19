import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public final class SortAnOutlineAtEveryLevel {

	public static void main(String[] args) {
		Outline outline_4spaces = initialiseOutline("""
			zeta
			    beta
			    gamma
			        lambda
			        kappa
			        mu
			    delta
			alpha
			    theta
			    iota
			    epsilon""");	
		
		Outline outline_1tab = initialiseOutline("""
			zeta
			    gamma
			        mu
			        lambda
			        kappa
			    delta
			    beta
			alpha
			    theta
			    iota
			    epsilon""");
		
		System.out.println("Given the text containing spaces: " + outline_4spaces);
		System.out.println("The ascending sorted text is: " + outline_4spaces.sort(Sort.ASCENDING));	
		System.out.println("The descending sorted text is: " + outline_4spaces.sort(Sort.DESCENDING));
		
		System.out.println("Given the text containing tabs: " + outline_1tab);
		System.out.println("The ascending sorted text is: " + outline_1tab.sort(Sort.ASCENDING));	
		System.out.println("The descending sorted text is: " + outline_1tab.sort(Sort.DESCENDING));
		
		try {
			System.out.println("Trying to parse the first bad outline:");
			@SuppressWarnings("unused")
			var outline_bad1 = initialiseOutline("""
				alpha
				    epsilon
					iota
				    theta
				zeta
				    beta
				    delta
				    gamma
				    	kappa
				        lambda
				        mu""");
		} catch (AssertionError error) {
			System.err.println(error.getMessage());
		}
		
		try {
			System.out.println("Trying to parse the second bad outline:");
			@SuppressWarnings("unused")
			var outlinebad2 = initialiseOutline("""
				zeta
				    beta
				   gamma
				        lambda
				         kappa
				        mu
				    delta
				alpha
				    theta
				    iota
				    epsilon""");
		} catch (AssertionError error) {
			System.err.println(error.getMessage());
		}
	}
	
	private static Outline initialiseOutline(String text) {
		OutlineEntry root = new OutlineEntry("", 0, null);
		List<OutlineEntry> children = new ArrayList<OutlineEntry>();
		children.addLast(root);
		
		String[] lines = text.split("\n");		
		String firstIndent = firstIndent(lines);		
		int parentIndex = 0;
		int previousIndent = 0;		
		
		if ( firstIndent.contains(" ") && firstIndent.contains("\t") ) {
			throw new AssertionError("Mixed tabs and spaces are not allowed");
		}
			
		for ( int i = 0; i < lines.length; i++ ) {
			List<String> splits = splitLine(lines[i]);
			String blank = splits.get(0);
			String content = splits.get(1);
			final int currentIndent = blank.length() / firstIndent.length();
			
			if ( currentIndent * firstIndent.length() != blank.length() ) {
				throw new AssertionError("Invalid indentation on line " + i);
			}
			
			if ( currentIndent > previousIndent ) {
				parentIndex = i;
			} else if ( currentIndent < previousIndent ) {
				parentIndex = parentIndex(children, currentIndent);
			}
			previousIndent = currentIndent;
		
			OutlineEntry entry = new OutlineEntry(content, currentIndent + 1, children.get(parentIndex));
			entry.parent.children.addLast(entry);
			children.add(entry);
		}
		
		return new Outline(root, firstIndent);		
	}		
	
	private static int parentIndex(List<OutlineEntry> children, int parentLevel) {
		for ( int i = children.size() - 1; i >= 0; i-- ) {
			if ( children.get(i).level == parentLevel ) {
				return i;
			}
		}
		
		return -1;	    	
	}
	
	private static String firstIndent(String[] lines) {
		for ( String line : lines ) {
			String indent = splitLine(line).getFirst();
			if ( ! indent.isEmpty() ) {
				return indent;
			}
		}
		
		return "    ";
	}	
	
	private static List<String> splitLine(String line) {
		for ( int i = 0; i < line.length(); i++ ) {
			final char ch = line.charAt(i);
			if ( ch != ' ' && ch != '\t' ) {
				return List.of( line.substring(0, i), line.substring(i) );
			}
		}
		
		return List.of( line, " " );
	}	
	
	private enum Sort { ASCENDING, DESCENDING }
			
    private static record Outline(OutlineEntry root, String baseIndent) {		
		
		public Outline sort(Sort aSort) {
			root.sort(aSort, 0);			
			return this;
		}
		
		public String toString() {
			return root.toString(baseIndent);
		}
		
	}
	
	private static class OutlineEntry implements Comparable<OutlineEntry> {
			
		public OutlineEntry(String aText, int aLevel, OutlineEntry aParent) {
			text = aText;
			level = aLevel;
			parent = aParent;
		}
		
		@Override
		public int compareTo(OutlineEntry other) {
			return text.compareTo(other.text);
		}			
		
		public OutlineEntry sort(Sort aSort, int aLevel) {
		    for ( OutlineEntry child : children ) {
		        child.sort(aSort, aLevel);
		    }
		
		    if ( aLevel == 0 || aLevel == level ) {
		    	switch ( aSort ) {
		    		case ASCENDING  -> Collections.sort(children, Comparator.naturalOrder());
		    		case DESCENDING -> Collections.sort(children, Comparator.reverseOrder());
		    	}
		    }
		
		    return this;
		}
		
		public String toString(String aBaseIndent) {
			String result = aBaseIndent.repeat(level) + text + "\n";
			
			for ( OutlineEntry child : children ) {
				result += child.toString(aBaseIndent);
			}
			
			return result;
		}
		
		private String text;
		private int level;
		OutlineEntry parent;
		List<OutlineEntry> children = new ArrayList<OutlineEntry>();
		
	}

}
