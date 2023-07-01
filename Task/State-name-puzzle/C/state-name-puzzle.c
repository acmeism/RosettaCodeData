#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define USE_FAKES 1

const char *states[] = {
#if USE_FAKES
	"New Kory", "Wen Kory", "York New", "Kory New", "New Kory",
#endif
	"Alabama", "Alaska", "Arizona", "Arkansas",
	"California", "Colorado", "Connecticut",
	"Delaware",
	"Florida", "Georgia", "Hawaii",
	"Idaho", "Illinois", "Indiana", "Iowa",
	"Kansas", "Kentucky", "Louisiana",
	"Maine", "Maryland", "Massachusetts", "Michigan",
	"Minnesota", "Mississippi", "Missouri", "Montana",
	"Nebraska", "Nevada", "New Hampshire", "New Jersey",
	"New Mexico", "New York", "North Carolina", "North Dakota",
	"Ohio", "Oklahoma", "Oregon",
	"Pennsylvania", "Rhode Island",
	"South Carolina", "South Dakota", "Tennessee", "Texas",
	"Utah", "Vermont", "Virginia",
	"Washington", "West Virginia", "Wisconsin", "Wyoming"
};

int n_states = sizeof(states)/sizeof(*states);
typedef struct { unsigned char c[26]; const char *name[2]; } letters;

void count_letters(letters *l, const char *s)
{
	int c;
	if (!l->name[0]) l->name[0] = s;
	else l->name[1] = s;

	while ((c = *s++)) {
		if (c >= 'a' && c <= 'z') l->c[c - 'a']++;
		if (c >= 'A' && c <= 'Z') l->c[c - 'A']++;
	}
}

int lcmp(const void *aa, const void *bb)
{
	int i;
	const letters *a = aa, *b = bb;
	for (i = 0; i < 26; i++)
		if      (a->c[i] > b->c[i]) return  1;
		else if (a->c[i] < b->c[i]) return -1;
	return 0;
}

int scmp(const void *a, const void *b)
{
	return strcmp(*(const char *const *)a, *(const char *const *)b);
}

void no_dup()
{
	int i, j;

	qsort(states, n_states, sizeof(const char*), scmp);

	for (i = j = 0; i < n_states;) {
		while (++i < n_states && !strcmp(states[i], states[j]));
		if (i < n_states) states[++j] = states[i];
	}

	n_states = j + 1;
}

void find_mix()
{
	int i, j, n;
	letters *l, *p;

	no_dup();
	n = n_states * (n_states - 1) / 2;
	p = l = calloc(n, sizeof(letters));

	for (i = 0; i < n_states; i++)
		for (j = i + 1; j < n_states; j++, p++) {
			count_letters(p, states[i]);
			count_letters(p, states[j]);
		}

	qsort(l, n, sizeof(letters), lcmp);

	for (j = 0; j < n; j++) {
		for (i = j + 1; i < n && !lcmp(l + j, l + i); i++) {
			if (l[j].name[0] == l[i].name[0]
				|| l[j].name[1] == l[i].name[0]
				|| l[j].name[1] == l[i].name[1])
				continue;
			printf("%s + %s => %s + %s\n",
				l[j].name[0], l[j].name[1], l[i].name[0], l[i].name[1]);
		}
	}
	free(l);
}

int main(void)
{
	find_mix();
	return 0;
}
