import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.IntStream;

public final class NestedTemplateData {

	public static void main(String[] args) {
		List<String> payloads = IntStream.rangeClosed(0, 6).mapToObj( i -> "Payload#" + i ).toList();
		String template = "[1, [[[1, 6]], [[3, 4, [17], 0], 5], 3], 9, [888], 9]";
		
		System.out.println("Level        Element");
		processPayloads(template, payloads);
	}
	
	private static void processPayloads(String template, List<String> payloads) {
		Set<String> unusedPayloads = new TreeSet<String>(payloads);
		Set<String> missingPayloads = new TreeSet<String>();
		int level = 0;
		boolean levelChanged = false;
		
		for ( int i = 0; i < template.length(); i++ ) {	
			String item = template.substring(i, i + 1);			
			switch ( item ) {
				case "[" -> { level += 1; levelChanged = true; }
				case "]" -> { level -= 1; levelChanged = true; }
				default -> {
					if ( isDigit(item) ) {
						while ( isDigit(template.substring(i + 1, i + 2)) ) {
							item += template.substring(i + 1, i + 2);
							i += 1;
						}						
						if ( levelChanged ) {
							System.out.println();
							System.out.print(String.format("%2s%s", level, "    ".repeat(level)));
							levelChanged = false;
						}
						String payload = "Payload#" + item;
						if ( payloads.contains(payload) ) {
							unusedPayloads.remove(payload);
						} else {					
							missingPayloads.add(payload);
							payload += " UNDEFINED";
						}
						System.out.print(payload + " ");
					}
				}
			}
		}
		
		System.out.println(System.lineSeparator());
		System.out.println(" Unused payloads: " + unusedPayloads);
		System.out.println();
		System.out.println(" Missing payloads: " + missingPayloads);
	}

	private static boolean isDigit(String item) {
		return item.compareTo("0") >= 0 && item.compareTo("9") <= 0;
	}

}
