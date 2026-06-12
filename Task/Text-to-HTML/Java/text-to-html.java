public final class TextToHTML {

	public static void main(String[] args) {
		String sampleText = """
			    Sample Text
			This is an example of converting plain text to HTML which demonstrates extracting a title and escaping certain characters within bulleted and numbered lists.
			* This is a bulleted list with a less than sign (<)
			* And this is its second line with a greater than sign (>)
			A 'normal' paragraph between the lists.
			1. This is a numbered list with an ampersand (&)
			2. "Second line" in double quotes
			3. 'Third line' in single quotes
			That's all folks.
		""";		
		
		boolean bulletedList = false;
		boolean numberedList = false;	
		List<String> paragraphs = splitParagraphs(escapeHTML(sampleText));
		String title = Character.isWhitespace(paragraphs.getFirst().charAt(0)) ?
			paragraphs.getFirst().strip() : "Untitled";		

		System.out.println("<html>");
		System.out.println("<head><title>" + title + "</title></head>");
		System.out.println("<body>");
		
		for ( int i = 1; i < paragraphs.size(); i++ ) {
		    String paragraph = paragraphs.get(i).strip();
		
		    if ( paragraph.startsWith("*") ) {
		        if ( ! bulletedList ) {
		            bulletedList = true;
		            System.out.println("<ul>");
		        }
		        System.out.println("  <li>" + paragraph.substring(1).strip() + "</li>");
		    } else if ( bulletedList ) {
		        bulletedList = false;
		        System.out.println("</ul>");
		    }
	
		    if ( Character.isDigit(paragraph.charAt(0)) && paragraph.charAt(1) == '.' ) {
		       if ( ! numberedList ) {
		            numberedList = true;
		            System.out.println("<ol>");
		       }
		       System.out.println("  <li>" + paragraph.substring(2).strip() + "</li>");
		    } else if ( numberedList ) {
		        numberedList = false;
		        System.out.println("</ol>");
		    }
		
		    if ( ! bulletedList && ! numberedList ) {
		    	System.out.println("<p>" + paragraph.strip() + "</p>");
		    }
		}
		
		if ( bulletedList ) {
			System.out.println("</ul>");
		}
		if ( numberedList ) {
			System.out.println("</ol>");
		}
		System.out.println("</body>");
		System.out.println("</html>");
	}
	
	private static List<String> splitParagraphs(String text) {
	    List<String> paragraphs = new ArrayList<String>();
	    StringBuilder builder = new StringBuilder();
	
	    for ( char ch : text.toCharArray() ) {
	        if ( ch == '\n' ) {
	        	if ( ! builder.toString().isBlank() ) {
	                paragraphs.addLast(builder.toString());
	                builder.setLength(0);
	        	}
	        } else {
	            builder.append(ch);
	        }
	    }
	
	    if ( ! builder.toString().isBlank() ) {
	        paragraphs.addLast(builder.toString());
	    }
	    return paragraphs;
	}
	
	private static String escapeHTML(String text) {
	    String result = text;
	    return result.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	
}
