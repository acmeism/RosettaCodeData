/* Abhishek Ghosh, 8th November 2013, Rotterdam */
#include <stdio.h>

#define sqr(x) ((x) * (x))
#define greet printf("Hello There!\n")

int twice(int x)
{
	return 2 * x;
}

int main(void)
{
	int x;

	printf("This will demonstrate function and label scopes.\n");
	printf("All output is happening through printf(), a function declared in the header stdio.h, which is external to this program.\n");
	printf("Enter a number: ");
	if (scanf("%d", &x) != 1)
		return 0;
	
	switch (x % 2) {
	default:
		printf("Case labels in switch statements have scope local to the switch block.\n");
	case 0:
		printf("You entered an even number.\n");
		printf("Its square is %d, which was computed by a macro. It has global scope within the translation unit.\n", sqr(x));
		break;
	case 1:
		printf("You entered an odd number.\n");
		goto sayhello;
	jumpin:
		printf("2 times %d is %d, which was computed by a function defined in this file. It has global scope within the translation unit.\n", x, twice(x));
		printf("Since you jumped in, you will now be greeted, again!\n");
	sayhello:
		greet;
		if (x == -1)
			goto scram;
		break;
	}

	printf("We now come to goto, it's extremely powerful but it's also prone to misuse. Its use is discouraged and it wasn't even adopted by Java and later languages.\n");

	if (x != -1) {
		x = -1;   /* To break goto infinite loop. */
	 	goto jumpin;
	}

scram:
	printf("If you are trying to figure out what happened, you now understand goto.\n");
	return 0;
}
