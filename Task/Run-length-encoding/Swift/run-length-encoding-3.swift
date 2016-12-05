// "3W1B2W" -> "WWWBWW"
func decode(encoded: String) -> String {
    let scanner = NSScanner(string: encoded)
    var char: NSString? = nil
    var count: Int = 0
    var out = ""

    while scanner.scanInteger(&count) {
        while scanner.scanCharactersFromSet(NSCharacterSet.letterCharacterSet(), intoString: &char) {
            out += String(count: count, repeatedValue: Character(char as! String))
        }
    }

    return out
}
