void main() {
	string code = "++++++++++[>+>+++>++++>+++++++>++++++++>+++++++++>++
++++++++>+++++++++++>++++++++++++<<<<<<<<<-]>>>>+.>>>
>+..<.<++++++++.>>>+.<<+.<<<<++++.<++.>>>+++++++.>>>.+++.
<+++++++.--------.<<<<<+.<+++.---.";

	bf(10, code);
}

void bf(int len, string input) {
	char[] data = new char[len];
	int data_pointer = 0;

	for (int i = 0; i < input.length; i++) {
		switch (input[i]) {
		case '>':
			data_pointer++;
			break;
		case '<':
			data_pointer--;
			break;
		case '+':
			data[data_pointer]++;
			break;
		case '-':
			data[data_pointer]--;
			break;
		case '.':
			stdout.printf("%c", data[data_pointer]);
			break;
		case ',':
			stdin.scanf("%c", &data[data_pointer]);
			break;
		case '[':
			if (data[data_pointer] == 0) {
				for (int nc = 1; nc > 0;) {
					i++;
					if (input[i] == '[') {
						nc++;
					}
					else if (input[i] == ']') {
						nc--;
					}
				}
			}
			break;
		case ']':
			if (data[data_pointer] != 0) {
				for (int nc = 1; nc > 0;) {
					i--;
					if (input[i] == ']') {
						nc++;
					}
					else if (input[i] == '[') {
						nc--;
					}
				}
			}
			break;
		}
	}
}
