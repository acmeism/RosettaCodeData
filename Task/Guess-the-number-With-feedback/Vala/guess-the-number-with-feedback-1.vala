void main(){
	const int from = 1;
	const int to = 100;

	int random = Random.int_range(from, to);	
	int guess = 0;

	while (guess != random){
		stdout.printf("Guess the target number that's between %d and %d.\n", from, to);

		string? num = stdin.read_line ();
		num.canon("0123456789", '!'); // replaces any character in num that's not in "0123456789" with "!"
		
		if ("!" in num)
			stdout.printf("Please enter a number!\n");

		else{		
			guess = int.parse(num);

			if (guess > random && guess <= to)
				stdout.printf("Too high!\n");
			if (guess < random && guess >= from)
				stdout.printf("Too low!\n");
			if (guess == random)
				stdout.printf("You guess it! You win!\n");
			if (guess < from || guess > to)
				stdout.printf("%d Your guess isn't even in the right range!\n", guess);
		}

	}//while
} // main
