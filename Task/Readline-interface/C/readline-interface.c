#include <readline/readline.h>
#include <readline/history.h>
#include <string.h>

int main()
{
	char *s;
	using_history();
	while (1) {
		s = readline("This be a prompt> ");

		if (!s || !strcmp(s, "quit")) {
			puts("bye.");
			return 0;
		}

		if (!strcmp(s, "help"))
			puts("commands: ls, cat, quit");
		else if (!strcmp(s, "ls") || !strcmp(s, "cat")) {
			printf("command `%s' not implemented yet.\n", s);
			add_history(s);
		} else
			puts("Yes...?");
	}
}
