#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

char *list;
const char *line = "--------+--------------------\n";
int len = 0;

int irand(int n)
{
	int r, rand_max = RAND_MAX - (RAND_MAX % n);
	do { r = rand(); } while(r >= rand_max);
	return r / (rand_max / n);
}

char* get_digits(int n, char *ret)
{
	int i, j;
	char d[] = "123456789";

	for (i = 0; i < n; i++) {
		j = irand(9 - i);
		ret[i] = d[i + j];
		if (j) d[i + j] = d[i], d[i] = ret[i];
	}
	return ret;
}

#define MASK(x) (1 << (x - '1'))
int score(const char *digits, const char *guess, int *cow)
{
	int i, bits = 0, bull = *cow = 0;

	for (i = 0; guess[i] != '\0'; i++)
		if (guess[i] != digits[i])
			bits |= MASK(digits[i]);
		else ++bull;

	while (i--) *cow += ((bits & MASK(guess[i])) != 0);

	return bull;
}

void pick(int n, int got, int marker, char *buf)
{
	int i, bits = 1;
	if (got >= n)
		strcpy(list + (n + 1) * len++, buf);
	else
		for (i = 0; i < 9; i++, bits *= 2) {
			if ((marker & bits)) continue;
			buf[got] = i + '1';
			pick(n, got + 1, marker | bits, buf);
		}
}

void filter(const char *buf, int n, int bull, int cow)
{
	int i = 0, c;
	char *ptr = list;

	while (i < len) {
		if (score(ptr, buf, &c) != bull || c != cow)
			strcpy(ptr, list + --len * (n + 1));
		else
			ptr += n + 1, i++;
	}
}

void game(const char *tgt, char *buf)
{
	int i, p, bull, cow, n = strlen(tgt);

	for (i = 0, p = 1; i < n && (p *= 9 - i); i++);
	list = malloc(p * (n + 1));

	pick(n, 0, 0, buf);
	for (p = 1, bull = 0; n - bull; p++) {
		strcpy(buf, list + (n + 1) * irand(len));
		bull = score(tgt, buf, &cow);

		printf("Guess %2d| %s    (from: %d)\n"
			"Score   | %d bull, %d cow\n%s",
			p, buf, len, bull, cow, line);

		filter(buf, n, bull, cow);
	}
}

int main(int c, char **v)
{
	int n = c > 1 ? atoi(v[1]) : 4;

	char secret[10] = "", answer[10] = "";
	srand(time(0));

	printf("%sSecret  | %s\n%s", line, get_digits(n, secret), line);
	game(secret, answer);

	return 0;
}
