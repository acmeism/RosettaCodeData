#include <stdio.h>

typedef enum { t_F = -1, t_M, t_T } trit;

trit t_not  (trit a) { return -a; }
trit t_and  (trit a, trit b) { return a < b ? a : b; }
trit t_or   (trit a, trit b) { return a > b ? a : b; }
trit t_eq   (trit a, trit b) { return a * b; }
trit t_imply(trit a, trit b) { return -a > b ? -a : b; }
char t_s(trit a) { return "F?T"[a + 1]; }

#define forall(a) for(a = t_F; a <= t_T; a++)
void show_op(trit (*f)(trit, trit), const char *name) {
	trit a, b;
	printf("\n[%s]\n    F ? T\n  -------", name);
	forall(a) {
		printf("\n%c |", t_s(a));
		forall(b) printf(" %c", t_s(f(a, b)));
	}
	puts("");
}

int main(void)
{
	trit a;

	puts("[Not]");
	forall(a) printf("%c | %c\n", t_s(a), t_s(t_not(a)));

	show_op(t_and,   "And");
	show_op(t_or,    "Or");
	show_op(t_eq,    "Equiv");
	show_op(t_imply, "Imply");

	return 0;
}
