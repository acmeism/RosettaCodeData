// Snake

// The problem with implementing this task in C is, the language standard
// does not cover some details essential for interactive games:
// a nonblocking keyboard input, a positional console output,
// a and millisecond-precision timer: these things are all system-dependent.

// Therefore the program is split in two pieces, a system-independent
// game logic, and a system-dependent UI, separated by a tiny API:
char nonblocking_getch();
void positional_putch(int x, int y, char ch);
void millisecond_sleep(int n);
void init_screen();
void update_screen();
void close_screen();

// The implementation of a system-dependent part.
// Requires POSIX IEEE 1003.1-2008 compliant system and ncurses library.
#ifdef __linux__
#define _POSIX_C_SOURCE 200809L
#include <time.h> // nanosleep
#include <ncurses.h> // getch, mvaddch, and others
char nonblocking_getch() { return getch(); }
void positional_putch(int x, int y, char ch) { mvaddch(x, y, ch); }
void millisecond_sleep(int n) {
	struct timespec t = { 0, n * 1000000 };
	nanosleep(&t, 0);
	// for older POSIX standards, consider usleep()
}
void update_screen() { refresh(); }
void init_screen() {
	initscr();
	noecho();
	cbreak();
	nodelay(stdscr, TRUE);
}
void close_screen() { endwin(); }
#endif

// An implementation for some other system...
#ifdef _WIN32
#error "not implemented"
#endif

// The game logic, system-independent
#include <time.h> // time
#include <stdlib.h> // rand, srand

#define w 80
#define h 40

int board[w * h];
int head;
enum Dir { N, E, S, W } dir;
int quit;

enum State { SPACE=0, FOOD=1, BORDER=2 };
// negative values denote the snake (a negated time-to-live in given cell)

// reduce a time-to-live, effectively erasing the tail
void age() {
        int i;
	for(i = 0; i < w * h; ++i)
		if(board[i] < 0)
			++board[i];
}

// put a piece of food at random empty position
void plant() {
	int r;
	do
		r = rand() % (w * h);
	while(board[r] != SPACE);
	board[r] = FOOD;
}

// initialize the board, plant a very first food item
void start(void) {
        int i;
	for(i = 0; i < w; ++i)
		board[i] = board[i + (h - 1) * w] = BORDER;
	for(i = 0; i < h; ++i)
		board[i * w] = board[i * w + w - 1] = BORDER;
	head = w * (h - 1 - h % 2) / 2; // screen center for any h
	board[head] = -5;
	dir = N;
	quit = 0;
	srand(time(0));
	plant();
}

void step() {
	int len = board[head];
	switch(dir) {
		case N: head -= w; break;
		case S: head += w; break;
		case W: --head; break;
		case E: ++head; break;
	}
	switch(board[head]) {
		case SPACE:
			board[head] = len - 1; // keep in mind len is negative
			age();
			break;
		case FOOD:
			board[head] = len - 1;
			plant();
			break;
		default:
			quit = 1;
	}
}

void show() {
	const char * symbol = " @.";
        int i;
	for(i = 0; i < w * h; ++i)
		positional_putch(i / w, i % w,
			board[i] < 0 ? '#' : symbol[board[i]]);
	update_screen();
}

int main (int argc, char * argv[]) {
	init_screen();
	start();
	do {
		show();
		switch(nonblocking_getch()) {
			case 'i': dir = N; break;
			case 'j': dir = W; break;
			case 'k': dir = S; break;
			case 'l': dir = E; break;
			case 'q': quit = 1; break;
		}
		step();
		millisecond_sleep(100); // beware, this approach
		// is not suitable for anything but toy projects like this
	}
	while(!quit);
	millisecond_sleep(999);
	close_screen();
	return 0;
}
