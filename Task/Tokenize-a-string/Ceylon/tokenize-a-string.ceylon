shared void tokenizeAString() {
	value input = "Hello,How,Are,You,Today";
	value tokens = input.split(','.equals);
	print(".".join(tokens));
}
