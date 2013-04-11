#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char input[] =
	"des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee\n"
	"dw01             ieee dw01 dware gtech\n"
	"dw02             ieee dw02 dware\n"
	"dw03             std synopsys dware dw03 dw02 dw01 ieee gtech\n"
	"dw04             dw04 ieee dw01 dware gtech\n"
	"dw05             dw05 ieee dware\n"
	"dw06             dw06 ieee dware\n"
	"dw07             ieee dware\n"
	"dware            ieee dware\n"
	"gtech            ieee gtech\n"
	"ramlib           std ieee\n"
	"std_cell_lib     ieee std_cell_lib\n"
	"synopsys\n"
	"cycle_11	  cycle_12\n"
	"cycle_12	  cycle_11\n"
	"cycle_21	  dw01 cycle_22 dw02 dw03\n"
	"cycle_22	  cycle_21 dw01 dw04";

typedef struct item_t item_t, *item;
struct item_t { const char *name; int *deps, n_deps, idx, depth; };

int get_item(item *list, int *len, const char *name)
{
	int i;
	item lst = *list;

	for (i = 0; i < *len; i++)
		if (!strcmp(lst[i].name, name)) return i;

	lst = *list = realloc(lst, ++*len * sizeof(item_t));
	i = *len - 1;
	memset(lst + i, 0, sizeof(item_t));
	lst[i].idx = i;
	lst[i].name = name;
	return i;
}

void add_dep(item it, int i)
{
	if (it->idx == i) return;
	it->deps = realloc(it->deps, (it->n_deps + 1) * sizeof(int));
	it->deps[it->n_deps++] = i;
}

int parse_input(item *ret)
{
	int n_items = 0;
	int i, parent, idx;
	item list = 0;

	char *s, *e, *word, *we;
	for (s = input; ; s = 0) {
		if (!(s = strtok_r(s, "\n", &e))) break;

		for (i = 0, word = s; ; i++, word = 0) {
			if (!(word = strtok_r(word, " \t", &we))) break;
			idx = get_item(&list, &n_items, word);

			if (!i) parent = idx;
			else    add_dep(list + parent, idx);
		}
	}

	*ret = list;
	return n_items;
}

/* recursively resolve compile order; negative means loop */
int get_depth(item list, int idx, int bad)
{
	int max, i, t;

	if (!list[idx].deps)
		return list[idx].depth = 1;

	if ((t = list[idx].depth) < 0) return t;

	list[idx].depth = bad;
	for (max = i = 0; i < list[idx].n_deps; i++) {
		if ((t = get_depth(list, list[idx].deps[i], bad)) < 0) {
			max = t;
			break;
		}
		if (max < t + 1) max = t + 1;
	}
	return list[idx].depth = max;
}

int main()
{
	int i, j, n, bad = -1, max, min;
	item items;
	n = parse_input(&items);

	for (i = 0; i < n; i++)
		if (!items[i].depth && get_depth(items, i, bad) < 0) bad--;

	for (i = 0, max = min = 0; i < n; i++) {
		if (items[i].depth > max) max = items[i].depth;
		if (items[i].depth < min) min = items[i].depth;
	}

	printf("Compile order:\n");
	for (i = min; i <= max; i++) {
		if (!i) continue;

		if (i < 0) printf("   [unorderable]");
		else	   printf("%d:", i);

		for (j = 0; j < n || !putchar('\n'); j++)
			if (items[j].depth == i)
				printf(" %s", items[j].name);
	}

	return 0;
}
