(
var text, words, sorted, dict = IdentityDictionary.new, findMax;
File.use("unixdict.txt".resolveRelative, "r", { |f| text = f.readAllString });
words = text.split(Char.nl);
sorted = words.collect { |each|
	var key = each.copy.sort.asSymbol;
	dict[key] ?? { dict[key] = [] };
	dict[key] = dict[key].add(each)
};
findMax = { |dict|
	var size = 0, max = [];
	dict.keysValuesDo { |key, val|
		if(val.size == size) { max = max.add(val) } {
			if(val.size > size) { max = []; size = val.size }
		}
	};
	max
};
findMax.(dict)
)
