int main (string[] args) {
	if (args.length < 2) {
		stdout.printf ("Please, input a string.\n");
		return 0;
	}
	var str = new StringBuilder ();
	for (var i = 1; i < args.length; i++) {
		str.append (args[i] + " ");
	}
	stdout.printf ("%s\n", str.str.strip ().reverse ());
	return 0;
}
