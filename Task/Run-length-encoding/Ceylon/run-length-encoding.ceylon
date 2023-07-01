shared void run() {

    "Takes a string such as aaaabbbbbbcc and returns 4a6b2c"
    String compress(String string) {
        if (exists firstChar = string.first) {
            if (exists index = string.firstIndexWhere((char) => char != firstChar)) {
                return "``index````firstChar````compress(string[index...])``";
            }
            else {
                return "``string.size````firstChar``";
            }
        }
        else {
            return "";
        }
    }

    "Takes a string such as 4a6b2c and returns aaaabbbbbbcc"
    String decompress(String string) =>
            let (runs = string.split(Character.letter, false).paired)
    		"".join {
        		for ([length, char] in runs)
        		if (is Integer int = Integer.parse(length))
        		char.repeat(int)
        	};

    assert (compress("aaaabbbbbaa") == "4a5b2a");
    assert (decompress("4a6b2c") == "aaaabbbbbbcc");
    assert (compress("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW") == "12W1B12W3B24W1B14W");
    assert (decompress("24a") == "aaaaaaaaaaaaaaaaaaaaaaaa");
}
