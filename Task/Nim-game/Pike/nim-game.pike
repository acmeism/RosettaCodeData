int tokens = 12;

void get_tokens(int cur_tokens) {
	write("How many tokens would you like to take? ");
	int take = (int)Stdio.stdin->gets();

	if (take < 1 || take > 3) {
		write("Number must be between 1 and 3.\n");
		get_tokens(cur_tokens);
	}
	else {
		tokens = cur_tokens - take;
		write("You take " + (string)take + " tokens\n");
		write((string)tokens + " tokens remaing\n\n");
	}
}

void comp_turn(int cur_tokens) {
	int take = cur_tokens % 4;
	tokens = cur_tokens - take;
	write("Computer take " + (string)take + " tokens\n");
	write((string)tokens + " tokens remaing\n\n");
}

int main() {
	write("Pike Nim\n\n");
	while(tokens > 0) {
		get_tokens(tokens);
		comp_turn(tokens);	
	}
	write("Computer wins!\n");
	return 0;
}
