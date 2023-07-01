import 'dart:io' show stdout, stdin;

main() {
	stdout.write('Enter a string: ');
	final string_input = stdin.readLineSync();

	int number_input;	

	do {
		stdout.write('Enter the number 75000: ');
		var number_input_string = stdin.readLineSync();

		try {
			number_input = int.parse(number_input_string);
			if (number_input != 75000)
				stdout.writeln('$number_input is not 75000!');
		} on FormatException {
			stdout.writeln('$number_input_string is not a valid number!');
		} catch ( e ) {
			stdout.writeln(e);
		}

	} while ( number_input != 75000 );

	stdout.writeln('input: $string_input\nnumber: $number_input');
}
