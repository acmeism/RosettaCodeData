#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// In column order, print out the given positions in chess notation.
// For example, when N = 8, the first solution printed is:
// "a1 b5 c8 d6 e3 f7 g2 h4"
static void print_positions(int x[], const size_t n) {
	static const char alphabet[] = "abcdefghijklmnopqrstuvwxyz";

	// There are only 26 letters in the ASCII alphabet, so
	// so don't bother with chess notation above 26.
	if (n <= 26) {
		for (size_t i = 0; i < n; ++i)
			printf("%c%u ", alphabet[i], x[i] + 1);
	} else {
		for (size_t i = 0; i < n; ++i)
			printf("%u ", x[i] + 1);
	}
    putchar('\n');
}

// Print all solutions to the N queens problem, holding the results in
// the intermediate array x, and with the auxiliary boolean arrays a, b, and c.
// x and a are both N elements long, while b and c are 2*N-1 elements long.
// It is assumed that these arrays are zeroed before this routine is called.
static void queens(int x[], bool a[], bool b[], bool c[], const size_t n) {
	size_t col, row = 0;

advance_row:
	if (row >= n) {
		print_positions(x, n);
		goto backtrack;
	}
	col = 0;
try_column:
	if (!a[col] && !b[col+row-1] && !c[col-row+n]) {
		a[col] = true;
		b[col+row-1] = true;
		c[col-row+n] = true;
		x[row] = col;
		row++;
		goto advance_row;
	}
try_again:
	if (col < n-1) {
		col++;
		goto try_column;
	}
backtrack:
	if (row != 0) {
		--row;
		col = x[row];
		c[col-row+n] = false;
		b[col+row-1] = false;
		a[col] = false;
		goto try_again;
	}
}

static void *calloc_wrapper(size_t count, size_t bytesize) {
	void *r;
	if ((r = calloc(count, bytesize)) == NULL) {
		exit(EXIT_FAILURE);
	}
	return r;
}

int main(int argc, char **argv) {
	bool *a, *b, *c;
	int n, *x;
	
	if (argc != 2 || (n = atoi(argv[1])) <= 0) {
		printf("%s: specify a natural number argument\n", argv[0]);
		return 1;
	}

	x = calloc_wrapper(n, sizeof(x[0]));
	a = calloc_wrapper(n, sizeof(a[0]));
	b = calloc_wrapper((2 * n - 1), sizeof(b[0]));
	c = calloc_wrapper((2 * n - 1), sizeof(c[0]));

	queens(x, a, b, c, n);

	// Don't bother freeing before exiting.
	return 0;
}
