"Run the module `menu`."
shared void run() {
 	value selection = menu("fee fie", "huff And puff", "mirror mirror", "tick tock");
 	print(selection);
}

String menu(String* strings) {
	if(strings.empty) {
		return "";
	}
	value entries = map(zipEntries(1..strings.size, strings));
	while(true) {
		for(index->string in entries) {
			print("``index``) ``string``");
		}
		process.write("> ");
		value input = process.readLine();
		if(exists input, exists int = parseInteger(input), exists string = entries[int]) {
			return string;
		}
	}
}
