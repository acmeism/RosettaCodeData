public static function rot13(input: String): String {
	var buf = new StringBuf();
	for (charInt in new haxe.iterators.StringIterator(input)) {
		if (charInt >= 0x41 && charInt <= 0x4d || charInt >= 0x61 && charInt <= 0x6d)
			charInt += 13;
		else if (charInt >= 0x4e && charInt <= 0x5a || charInt >= 0x6e && charInt <= 0x7a)
			charInt -= 13;
		buf.addChar(charInt);
	}
	return buf.toString();
}
