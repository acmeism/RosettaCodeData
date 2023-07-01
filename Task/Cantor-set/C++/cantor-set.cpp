#include <iostream>

const int WIDTH = 81;
const int HEIGHT = 5;

char lines[WIDTH*HEIGHT];

void cantor(int start, int len, int index) {
	int seg = len / 3;
	if (seg == 0) return;
	for (int i = index; i < HEIGHT; i++) {
		for (int j = start + seg; j < start + seg * 2; j++) {
			int pos = i * WIDTH + j;
			lines[pos] = ' ';
		}
	}
	cantor(start,           seg, index + 1);
	cantor(start + 2 * seg, seg, index + 1);
}

int main() {
	// init
	for (int i = 0; i < WIDTH*HEIGHT; i++) {
		lines[i] = '*';
	}

	// calculate
	cantor(0, WIDTH, 1);

	// print
	for (int i = 0; i < HEIGHT*WIDTH; i += WIDTH) {
		printf("%.*s\n", WIDTH, lines + i);
	}

	return 0;
}
