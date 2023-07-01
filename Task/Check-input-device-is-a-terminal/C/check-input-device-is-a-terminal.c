#include <unistd.h>	//for isatty()
#include <stdio.h>	//for fileno()

int main(void)
{
	puts(isatty(fileno(stdin))
		? "stdin is tty"
		: "stdin is not tty");
	return 0;
}
