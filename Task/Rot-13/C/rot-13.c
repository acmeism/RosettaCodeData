#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

static char rot13_table[UCHAR_MAX + 1];

static void init_rot13_table(void) {
	static const unsigned char upper[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	static const unsigned char lower[] = "abcdefghijklmnopqrstuvwxyz";

	for (int ch = '\0'; ch <= UCHAR_MAX; ch++) {
		rot13_table[ch] = ch;
	}
	for (const unsigned char *p = upper; p[13] != '\0'; p++) {
		rot13_table[p[0]] = p[13];
		rot13_table[p[13]] = p[0];
	}
	for (const unsigned char *p = lower; p[13] != '\0'; p++) {
		rot13_table[p[0]] = p[13];
		rot13_table[p[13]] = p[0];
	}
}

static void rot13_file(FILE *fp)
{
	int ch;
	while ((ch = fgetc(fp)) != EOF) {
		fputc(rot13_table[ch], stdout);
	}
}

int main(int argc, char *argv[])
{
	init_rot13_table();

	if (argc > 1) {
		for (int i = 1; i < argc; i++) {
			FILE *fp = fopen(argv[i], "r");
			if (fp == NULL) {
				perror(argv[i]);
				return EXIT_FAILURE;
			}
			rot13_file(fp);
			fclose(fp);
		}
	} else {
		rot13_file(stdin);
	}
	return EXIT_SUCCESS;
}
