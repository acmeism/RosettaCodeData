import Swift

func canMake(word: String) -> Bool {
	var blocks = [
		"BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
		"JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"
	]
	
	for letter in word.uppercased().characters {
		guard let index = blocks.index(where: { $0.characters.contains(letter) }) else {
			return false
		}
		
		blocks.remove(at: index)
	}
	
	return true
}

let words = ["a", "bARK", "boOK", "TreAt", "CoMmon", "SquAd", "CONFUse"]

words.forEach { print($0, canMake(word: $0)) }
