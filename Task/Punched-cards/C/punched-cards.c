#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static int punch(char const *text) {
	size_t n = strlen(text);
	if(n > 80) {
		fprintf(stderr, "Text too long\n");
		return EXIT_FAILURE;
	}
	#define P_HOLES(...) (char[]){__VA_ARGS__}
	#define P(P_CHAR,...) [P_CHAR] = { \
		.n = sizeof(P_HOLES(__VA_ARGS__))/sizeof(char), \
		.hole = P_HOLES(__VA_ARGS__), \
	}
	struct punch {
		size_t n;
		char  *hole;
	} punch[128] = {
		// https://dl.acm.org/doi/pdf/10.1145/362991.363052
		// 2.1 CODE TABLE
		P('\t',12,9,5),
		P('\v',12,9,8,3),
		P('\f',12,9,8,4),
		/**/           P('0',0),
		P('!', 12,8,7),P('1',1),
		P('"', 8,7),   P('2',2),
		P('#', 8,3),   P('3',3),
		P('$', 11,8,3),P('4',4),
		P('%', 0,8,4), P('5',5),
		P('&', 12),    P('6',6),
		P('\'',8,5),   P('7',7),
		P('(', 12,8,5),P('8',8),
		P(')', 11,8,5),P('9',9),
		P('*', 11,8,4),P(':',8,2),
		P('+', 12,8,6),P(';',11,8,6),
		P(',', 0,8,3), P('<',12,8,4),
		P('-', 11),    P('=',8,6),
		P('.', 12,8,3),P('>',0,8,6),
		P('/', 0,1),   P('?',0,8,7),
		
		P('@',8,4),    P('P', 11,7),
		P('A',12,1),   P('Q', 11,8),
		P('B',12,2),   P('R', 11,9),
		P('C',12,3),   P('S', 0,2),
		P('D',12,4),   P('T', 0,3),
		P('E',12,5),   P('U', 0,4),
		P('F',12,6),   P('V', 0,5),
		P('G',12,7),   P('W', 0,6),
		P('H',12,8),   P('X', 0,7),
		P('I',12,9),   P('Y', 0,8),
		P('J',11,1),   P('Z', 0,9),
		P('K',11,2),   P('[', 12,8,2),
		P('L',11,3),   P('\\',0,8,2),
		P('M',11,4),   P(']', 11,8,2),
		P('N',11,5),   P('^', 11,8,7),
		P('O',11,6),   P('_', 0,8,5),
				
		P('`',8,1),    P('p',12,11,7),
		P('a',12,0,1), P('q',12,11,8),
		P('b',12,0,2), P('r',12,11,9),
		P('c',12,0,3), P('s',11,0,2),
		P('d',12,0,4), P('t',11,0,3),
		P('e',12,0,5), P('u',11,0,4),
		P('f',12,0,6), P('v',11,0,5),
		P('g',12,0,7), P('w',11,0,6),
		P('h',12,0,8), P('x',11,0,7),
		P('i',12,0,9), P('y',11,0,8),
		P('j',12,11,1),P('z',11,0,9),
		P('k',12,11,2),P('{',12,0),
		P('l',12,11,3),P('|',12,11),
		P('m',12,11,4),P('}',11,0),
		P('n',12,11,5),P('~',11,0,1),
		P('o',12,11,6),P(127,12,9,7),
	};
	#undef P
	#undef P_HOLES
	char card[13][81];
	memset(card, ' ', sizeof(card));
	for(int i = 0; i < 13; i++) {
		card[i][80] = '\0';
	}
	for(int i = 0; i < n; i++) {
		int c = text[i] & 127;
		for(int j = 0; j < punch[c].n; j++) {
			card[punch[c].hole[j]][i] = 'x';
		}
	}
	putchar(' ');
	putchar('/');
	for(int i = 1; i < 80; i++) {
		putchar('-');
	}
	putchar('+');
	putchar('\n');
	putchar('/');
	for(int i = 0; i < n; i++) {
		if(isgraph(text[i])) putchar(text[i]);
		else putchar(' ');
	}
	for(int i = n; i < 80; i++) {
		putchar(' ');
	}
	putchar('|');
	putchar('\n');
	printf("|%s|\n", card[12]);
	printf("|%s|\n", card[11]);
	for(int i = 0; i < 10; i++) {
		printf("|%s|\n", card[i]);
	}
	putchar('+');
	for(int i = 0; i < 80; i++) {
		putchar('-');
	}
	putchar('+');
	putchar('\n');
	return EXIT_SUCCESS;
}

int main(int argc, char **argv) {
	static char *hello_world[] = {
		"#include <stdio.h>",
		"int main(int argc, char *argv[]) {",
		"	puts(\"\\\"Hello World!\\\"\");",
		"	return 0;",
		"}",
		NULL
	};
	int exit_code;
	char **text = (argc > 1) ? argv + 1 : hello_world;
	for(int i = 0; text[i]; i++) {
		if(i > 0) putchar('\n');
		exit_code = punch(text[i]);
		if(exit_code != EXIT_SUCCESS) break;
	}
	return exit_code;
}

