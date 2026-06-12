#include <ncurses.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

/* option: how long a line is. Options probably should have been made into
* commandline args, if I were not lazy.  Also, if line_len is set to 3,
* the game may keep going indefinitely: best use auto mode. */
int line_len = 5;

/* option: whether two lines are allowed to be in the same direction and
* connected end to end.  Note: two lines crossing are always ok. */
int disjoint = 0;

int **board = 0, width, height;

#define for_i for(i = 0; i < height; i++)
#define for_j for(j = 0; j < width; j++)
enum {
	s_blank		= 0,
	s_occupied	= 1 << 0,
	s_dir_ns	= 1 << 1,
	s_dir_ew	= 1 << 2,
	s_dir_ne_sw	= 1 << 3,
	s_dir_nw_se	= 1 << 4,
	s_newly_added	= 1 << 5,
	s_current	= 1 << 6,
};

int irand(int n)
{
	int r, rand_max = RAND_MAX - (RAND_MAX % n);
	while ((r = rand()) >= rand_max);
	return r / (rand_max / n);
}

int** alloc_board(int w, int h)
{
	int i;
	int **buf = calloc(1, sizeof(int *) * h + sizeof(int) * h * w);

	buf[0] = (int*)(buf + h);
	for (i = 1; i < h; i++)
		buf[i] = buf[i - 1] + w;
	return buf;
}

/* -1: expand low index end; 1: exten high index end */
void expand_board(int dw, int dh)
{
	int i, j;
	int nw = width + !!dw, nh = height + !!dh;

	/* garanteed to fragment heap: not realloc because copying elements
	 * is a bit tricky */
	int **nbuf = alloc_board(nw, nh);

	dw = -(dw < 0), dh = -(dh < 0);

	for (i = 0; i < nh; i++) {
		if (i + dh < 0 || i + dh >= height) continue;
		for (j = 0; j < nw; j++) {
			if (j + dw < 0 || j + dw >= width) continue;
			nbuf[i][j] = board[i + dh][j + dw];
		}
	}
	free(board);

	board = nbuf;
	width = nw;
	height = nh;
}

void array_set(int **buf, int v, int x0, int y0, int x1, int y1)
{
	int i, j;
	for (i = y0; i <= y1; i++)
		for (j = x0; j <= x1; j++)
			buf[i][j] = v;
}

void show_board()
{
	int i, j;
	for_i for_j mvprintw(i + 1, j * 2,
			(board[i][j] & s_current) ? "X "
			: (board[i][j] & s_newly_added) ? "O "
			: (board[i][j] & s_occupied) ? "+ " : "  ");
	refresh();
}

void init_board()
{
	width = height = 3 * (line_len - 1);
	board = alloc_board(width, height);

	array_set(board, s_occupied, line_len - 1, 1, 2 * line_len - 3, height - 2);
	array_set(board, s_occupied, 1, line_len - 1, width - 2, 2 * line_len - 3);

	array_set(board, s_blank, line_len, 2, 2 * line_len - 4, height - 3);
	array_set(board, s_blank, 2, line_len, width - 3, 2 * line_len - 4);
}

int ofs[4][3] = {
	{0, 1, s_dir_ns},
	{1, 0, s_dir_ew},
	{1, -1, s_dir_ne_sw},
	{1, 1, s_dir_nw_se}
};

typedef struct { int m, s, seq, x, y; } move_t;

/* test if a point can complete a line, or take that point */
void test_postion(int y, int x, move_t * rec)
{
	int m, k, s, dx, dy, xx, yy, dir;
	if (board[y][x] & s_occupied) return;

	for (m = 0; m < 4; m++) { /* 4 directions */
		dx = ofs[m][0];
		dy = ofs[m][1];
		dir = ofs[m][2];

		for (s = 1 - line_len; s <= 0; s++) { /* offset line */
			for (k = 0; k < line_len; k++) {
				if (s + k == 0) continue;

				xx = x + dx * (s + k);
				yy = y + dy * (s + k);
				if (xx < 0 || xx >= width || yy < 0 || yy >= height)
					break;

				/* no piece at position */
				if (!(board[yy][xx] & s_occupied)) break;

				/* this direction taken */
				if ((board[yy][xx] & dir)) break;
			}
			if (k != line_len) continue;

			/* position ok; irand() to even each option's chance of
			   being picked */
			if (! irand(++rec->seq))
				rec->m = m, rec->s = s, rec->x = x, rec->y = y;
		}
	}
}

void add_piece(move_t *rec) {
	int dx = ofs[rec->m][0];
	int dy = ofs[rec->m][1];
	int dir= ofs[rec->m][2];
	int xx, yy, k;

	board[rec->y][rec->x] |= (s_current | s_occupied);

	for (k = 0; k < line_len; k++) {
		xx = rec->x + dx * (k + rec->s);
		yy = rec->y + dy * (k + rec->s);
		board[yy][xx] |= s_newly_added;
		if (k >= disjoint || k < line_len - disjoint)
			board[yy][xx] |= dir;
	}
}

int next_move()
{
	int i, j;
	move_t rec;
	rec.seq = 0;

	/* wipe last iteration's new line markers */
	for_i for_j board[i][j] &= ~(s_newly_added | s_current);

	/* randomly pick one of next legal moves */
	for_i for_j test_postion(i, j, &rec);

	/* didn't find any move, game over */
	if (!rec.seq) return 0;

	add_piece(&rec);

	rec.x = (rec.x == width  - 1) ? 1 : rec.x ? 0 : -1;
	rec.y = (rec.y == height - 1) ? 1 : rec.y ? 0 : -1;

	if (rec.x || rec.y) expand_board(rec.x, rec.y);
	return 1;
}

int main()
{
	int ch = 0;
	int move = 0;
	int wait_key = 1;

	init_board();
	srand(time(0));

	initscr();
	noecho();
	cbreak();

	do  {
		mvprintw(0, 0, "Move %d", move++);
		show_board();
		if (!next_move()) {
			next_move();
			show_board();
			break;
		}
		if (!wait_key) usleep(100000);
		if ((ch = getch()) == ' ') {
			wait_key = !wait_key;
			if (wait_key) timeout(-1);
			else timeout(0);
		}
	} while (ch != 'q');

	timeout(-1);
	nocbreak();
	echo();

	endwin();
	return 0;
}
