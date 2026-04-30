import module java.base;

public final class PhraseReversals {

	public static void main() {
		String original = "rosetta code phrase reversal";
		
		IO.print("Reverse the string: ");		
		IO.println(Stream.of(original.split("")).reduce( "", (r, c) -> c + r ));		
		
		IO.print("Reverse each word : ");
		IO.println(Stream.of(original.split(" "))
            .map( word -> Stream.of(word.split("")).reduce( "", (r, c) -> c + r ) )
            .collect(Collectors.joining(" ")));
		
		IO.print("Reverse word order: ");		
		IO.println(String.join(" ", Stream.of(original.split(" "))
            .collect(LinkedList::new, LinkedList::addFirst, (a, b) -> a.addAll(0, b))));
	}

}
