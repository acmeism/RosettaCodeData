#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

typedef struct { const char *s; int ln, bad; } rec_t;
int cmp_rec(const void *aa, const void *bb)
{
	const rec_t *a = aa, *b = bb;
	return a->s == b->s ? 0 : !a->s ? 1 : !b->s ? -1 : strncmp(a->s, b->s, 10);
}

int read_file(const char *fn)
{
	int fd = open(fn, O_RDONLY);
	if (fd == -1) return 0;

	struct stat s;
	fstat(fd, &s);

	char *txt = malloc(s.st_size);
	read(fd, txt, s.st_size);
	close(fd);

	int i, j, lines = 0, k, di, bad;
	for (i = lines = 0; i < s.st_size; i++)
		if (txt[i] == '\n') {
			txt[i] = '\0';
			lines++;
		}

	rec_t *rec = calloc(sizeof(rec_t), lines);
	const char *ptr, *end;
	rec[0].s = txt;
	rec[0].ln = 1;
	for (i = 0; i < lines; i++) {
		if (i + 1 < lines) {
			rec[i + 1].s = rec[i].s + strlen(rec[i].s) + 1;
			rec[i + 1].ln = i + 2;
		}
		if (sscanf(rec[i].s, "%4d-%2d-%2d", &di, &di, &di) != 3) {
			printf("bad line %d: %s\n", i, rec[i].s);
			rec[i].s = 0;
			continue;
		}
		ptr = rec[i].s + 10;

		for (j = k = 0; j < 25; j++) {
			if (!strtod(ptr, (char**)&end) && end == ptr) break;
			k++, ptr = end;
			if (!(di = strtol(ptr, (char**)&end, 10)) && end == ptr) break;
			k++, ptr = end;
			if (di < 1) rec[i].bad = 1;
		}

		if (k != 48) {
			printf("bad format at line %d: %s\n", i, rec[i].s);
			rec[i].s = 0;
		}
	}

	qsort(rec, lines, sizeof(rec_t), cmp_rec);
	for (i = 1, bad = rec[0].bad, j = 0; i < lines && rec[i].s; i++) {
		if (rec[i].bad) bad++;
		if (strncmp(rec[i].s, rec[j].s, 10)) {
			j = i;
		} else
			printf("dup line %d: %.10s\n", rec[i].ln, rec[i].s);
	}

	free(rec);
	free(txt);
	printf("\n%d out %d lines good\n", lines - bad, lines);
	return 0;
}

int main()
{
	read_file("readings.txt");
	return 0;
}
