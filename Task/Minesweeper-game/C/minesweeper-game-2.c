#include <ncurses.h>
#include <locale.h>
#include <stdlib.h>

int width = 0, height = 0;
int mine_ratio = 10, n_mines;
int reveal = 0;

WINDOW *win, *wrap;

enum {
	M_NONE = 0,
	M_CLEARED = 1 << 0,
	M_MARKED  = 1 << 1,
	M_MINED   = 1 << 2,
	M_BOMBED  = 1 << 3,
};
typedef struct { unsigned short flag, cnt; } mine_t;

#define for_i for (int i = 0; i < height; i++)
#define for_j for (int j = 0; j < width; j++)
void init_mines(void * ptr)
{
	mine_t (*m)[width] = ptr;
	for_i for_j
		if (rand() % mine_ratio)
			m[i][j].flag = M_NONE;
		else {
			m[i][j].flag = M_MINED;
			n_mines ++;
		}

	for_i for_j {
		m[i][j].cnt = 0;
		for (int x = j - 1; x <= j + 1; x++) {
			if (x < 0 || x > width) continue;
			for (int y = i - 1; y <= i + 1; y++) {
				if (y < 0 || y >= width) continue;
				m[i][j].cnt += 1 && (m[y][x].flag & M_MINED);
			}
		}
	}
}

int mine_clear(void *ptr, int x, int y, int mass_clear)
{
	mine_t (*m)[width] = ptr;
	unsigned short flag;
	if (x < 0 || x >= width || y < 0 || y >= height)
		return 1;
	flag = m[y][x].flag;

	if (((flag & M_CLEARED) && 1) != mass_clear) return 1;

	if ((flag & M_MINED) && !(flag & M_MARKED)) {
		m[y][x].flag |= M_BOMBED;
		reveal = 1;
		return 0;
	}

	if (!(flag & M_MARKED))
		flag = (m[y][x].flag |= M_CLEARED);

	if (m[y][x].cnt && !mass_clear) return 1;
	if (flag & M_MARKED) return 1;

	for (int i = y - 1; i <= y + 1; i++)
		for (int j = x - 1; j <= x + 1; j++)
			if (!mine_clear(ptr, j, i, 0)) return 0;
	return 1;
}

void mine_mark(void *ptr, int x, int y)
{
	mine_t (*m)[width] = ptr;
	if (m[y][x].flag & M_CLEARED) return;
	if (m[y][x].flag & M_MARKED)
		n_mines ++;
	else
		n_mines --;
	m[y][x].flag ^= M_MARKED;
}

int check_wining(void *ptr)
{
	mine_t (*m)[width] = ptr;
	int good = 1;
	for_i for_j {
		int f = m[i][j].flag;
		if ((f & M_MINED) && !(f & M_MARKED)) {
			m[i][j].flag = M_BOMBED;
			good = 0;
		}
	}
	mvwprintw(wrap, height + 1, 0, good ? "All clear!    " : "BOOM!           ");
	reveal = 1;
	return good;
}

void repaint(void *ptr)
{
	mine_t (*m)[width] = ptr, *p;
	box(win, 0, 0);
	for_i for_j {
		char c;
		p = &m[i][j];
		int f = p->flag;
		if (reveal)
			c = (f & M_BOMBED) ? 'X' : (f & M_MINED) ? 'o' : ' ';
		else if (p->flag & M_BOMBED)
			c = 'X';
		else if (p->flag & M_MARKED)
			c = '?';
		else if (p->flag & M_CLEARED)
			c = p->cnt ? p->cnt + '0' : ' ';
		else
			c = '.';
		mvwprintw(win, i + 1, 2 * j + 1, " %c", c);
	}
	if (reveal);
	else if (n_mines)
		mvwprintw(wrap, height + 1, 0, "Mines:%6d   ", n_mines);
	else
		mvwprintw(wrap, height + 1, 0, "Claim victory?    ");
	wrefresh(wrap);
	wrefresh(win);
}

int main(int c, char **v)
{
	MEVENT evt;

	printf("%d\n", c);

	if (c >= 3) {
		height = atoi(v[1]);
		width = atoi(v[2]);
	}
	if (height < 3) height = 15;
	if (width < 3) width = 30;

	initscr();
	int mines[height][width];
	init_mines(mines);

	win = newwin(height + 2, 2 * width + 2, 0, 0);
	wrap = newwin(height + 3, 2 * width + 2, 1, 0);

	keypad(wrap, 1);
	mousemask(BUTTON1_CLICKED | BUTTON2_CLICKED | BUTTON3_CLICKED, 0);

	while (1) {
		int ch;
		repaint(mines);
		if ((ch = wgetch(wrap)) != KEY_MOUSE) {
			if (ch != 'r') break;
			reveal = !reveal;
			continue;
		}

		if (getmouse(&evt) != OK) continue;

		if ((evt.bstate & BUTTON1_CLICKED)) {
			if (evt.y == height + 2 && !n_mines) {
				check_wining(mines);
				break;
			}
			if (!mine_clear(mines, (evt.x - 1) / 2, evt.y - 1, 0))
				break;
		}
		else if ((evt.bstate & BUTTON2_CLICKED)) {
			if (!mine_clear(mines, (evt.x - 1) / 2, evt.y - 1, 1))
				break;
		}
		else if ((evt.bstate & BUTTON3_CLICKED))
			mine_mark(mines, (evt.x - 1)/2, evt.y - 1);
	}
	repaint(mines);

	mousemask(0, 0);
	keypad(wrap, 0);
	endwin();
	return 0;
}
