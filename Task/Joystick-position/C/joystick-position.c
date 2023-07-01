#include <stdio.h>
#include <stdlib.h>

void clear() {
	for(int n = 0;n < 10; n++) {
		printf("\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\r\n\r\n\r\n");
	}
}

#define UP    "00^00\r\n00|00\r\n00000\r\n"
#define DOWN  "00000\r\n00|00\r\n00v00\r\n"
#define LEFT  "00000\r\n<--00\r\n00000\r\n"
#define RIGHT "00000\r\n00-->\r\n00000\r\n"
#define HOME  "00000\r\n00+00\r\n00000\r\n"

int main() {
	clear();
	system("stty raw");

	printf(HOME);
	printf("space to exit; wasd to move\r\n");
	char c = 1;

	while(c) {
		c = getc(stdin);
		clear();

		switch (c)
		{
			case 'a':
				printf(LEFT);
				break;
			case 'd':
				printf(RIGHT);
				break;
			case 'w':
				printf(UP);
				break;
			case 's':
				printf(DOWN);
				break;
			case ' ':
				c = 0;
				break;
			default:
				printf(HOME);
		};

		printf("space to exit; wasd key to move\r\n");
	}

	system("stty cooked");
	system("clear");
	return 1;
}
