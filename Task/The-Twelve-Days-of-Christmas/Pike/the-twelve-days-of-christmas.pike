int main() {
	array(string) days = ({"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"});
	array(string) gifts = ({"A partridge in a pear tree.", "Two turtle doves and", "Three french hens", "Four calling birds", "Five golden rings", "Six geese a-laying", "Seven swans a-swimming", "Eight maids a-milking", "Nine ladies dancing", "Ten lords a-leaping", "Eleven pipers piping", "Twelve drummers drumming"});

	for (int i = 0; i < 12; i++) {
		write("On the " + (string)days[i] + " day of Christmas\n");
		write("My true love gave to me:\n");
		for (int j = 0; j < i + 1; j++) {
			write((string)gifts[i - j] + "\n");
		}
		if (i != 11) {
			write("\n");
		}
	}
	return 0;
}
