shared void run() {

	function pangram(String sentence) =>
 		let(alphabet = set('a'..'z'),
			letters = set(sentence.lowercased.filter(alphabet.contains)))
 		letters == alphabet;

 	value sentences = [
 		"The quick brown fox jumps over the lazy dog",
 		"""Watch "Jeopardy!", Alex Trebek's fun TV quiz game.""",
 		"Pack my box with five dozen liquor jugs.",
 		"blah blah blah"
 	];
 	for(sentence in sentences) {
 		print("\"``sentence``\" is a pangram? ``pangram(sentence)``");
 	}
}
