#include <stdio.h>

const char *input =
	"Character,Speech\n"
	"The multitude,The messiah! Show us the messiah!\n"
	"Brians mother,<angry>Now you listen here! He's not the messiah; "
		"he's a very naughty boy! Now go away!</angry>\n"
	"The multitude,Who are you?\n"
	"Brians mother,I'm his mother; that's who!\n"
	"The multitude,Behold his mother! Behold his mother!";

int main()
{
	const char *s;
	printf("<table>\n<tr><td>");
	for (s = input; *s; s++) {
		switch(*s) {
		case '\n': printf("</td></tr>\n<tr><td>"); break;
		case ',':  printf("</td><td>"); break;
		case '<':  printf("&lt;"); break;
		case '>':  printf("&gt;"); break;
		case '&':  printf("&amp;"); break;
		default:   putchar(*s);
		}
	}
	puts("</td></tr>\n</table>");

	return 0;
}
