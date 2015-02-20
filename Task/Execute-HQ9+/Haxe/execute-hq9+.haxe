// live demo: http://try.haxe.org/#2E7D4
static function hq9plus(code:String):String {
	var out:String = "";
	var acc:Int = 0;
	for (position in 0 ... code.length) switch (code.charAt(position)) {
		case "H", "h": out += "Hello, World!\n";
		case "Q", "q": out += '$code\n';
		case "9":
			var quantity:Int = 99;
			while (quantity > 1) {
				out += '$quantity bottles of beer on the wall, $quantity bottles of beer.\n';
				out += 'Take one down and pass it around, ${--quantity} bottles of beer.\n';
			}
			out += "1 bottle of beer on the wall, 1 bottle of beer.\n" +
				"Take one down and pass it around, no more bottles of beer on the wall.\n\n" +
				"No more bottles of beer on the wall, no more bottles of beer.\n" +
				"Go to the store and buy some more, 99 bottles of beer on the wall.\n";
		case "+": acc++;
	}
	return out;
}
