#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct letter_group_t {
	char c;
	int count;
} *letter_p;

struct letter_group_t all_letters[26];
letter_p letters[26];

/* counts how many of each letter is in a string, used later
 * to generate permutations
 */
int count_letters(const char *s)
{
	int i, c;
	for (i = 0; i < 26; i++) {
		all_letters[i].count = 0;
		all_letters[i].c = i + 'a';
	}
	while (*s != '\0') {
		i = *(s++);

		/* don't want to deal with bad inputs */
		if (i < 'a' || i > 'z') {
			fprintf(stderr, "Abort: Bad string %s\n", s);
			exit(1);
		}

		all_letters[i - 'a'].count++;
	}
	for (i = 0, c = 0; i < 26; i++)
		if (all_letters[i].count)
			letters[c++] = all_letters + i;

	return c;
}

int least_overlap, seq_no;
char out[100], orig[100], best[100];

void permutate(int n_letters, int pos, int overlap)
{
	int i, ol;
	if (pos < 0) {
                /* if enabled will show all shuffles no worse than current best */
	//	printf("%s: %d\n", out, overlap);

                /* if better than current best, replace it and reset counter */
		if (overlap < least_overlap) {
			least_overlap = overlap;
			seq_no = 0;
		}

                /* the Nth best tie has 1/N chance of being kept, so all ties
                 * have equal chance of being selected even though we don't
                 * how many there are before hand
                 */
		if ( (double)rand() / (RAND_MAX + 1.0) * ++seq_no <= 1)
			strcpy(best, out);

		return;
	}

        /* standard "try take the letter; try take not" recursive method */
	for (i = 0; i < n_letters; i++) {
		if (!letters[i]->count) continue;

		out[pos] = letters[i]->c;
		letters[i]->count --;
		ol = (letters[i]->c == orig[pos]) ? overlap + 1 : overlap;

                /* but don't try options that's already worse than current best */
		if (ol <= least_overlap)
			permutate(n_letters, pos - 1, ol);

		letters[i]->count ++;
	}
	return;
}

void do_string(const char *str)
{
	least_overlap = strlen(str);
	strcpy(orig, str);

	seq_no = 0;
	out[least_overlap] = '\0';
	least_overlap ++;

	permutate(count_letters(str), least_overlap - 2, 0);
	printf("%s -> %s, overlap %d\n", str, best, least_overlap);
}

int main()
{
	srand(time(0));
	do_string("abracadebra");
	do_string("grrrrrr");
	do_string("elk");
	do_string("seesaw");
	do_string("");
	return 0;
}
