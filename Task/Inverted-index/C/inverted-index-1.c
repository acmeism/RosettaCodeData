#include <stdio.h>
#include <stdlib.h>

char chr_legal[] = "abcdefghijklmnopqrstuvwxyz0123456789_-./";
int  chr_idx[256] = {0};
char idx_chr[256] = {0};

#define FNAME 0
typedef struct trie_t *trie, trie_t;
struct trie_t {
	trie next[sizeof(chr_legal)]; /* next letter; slot 0 is for file name */
	int eow;
};

trie trie_new() { return calloc(sizeof(trie_t), 1); }

#define find_word(r, w) trie_trav(r, w, 1)
/* tree traversal: returns node if end of word and matches string, optionally
 * create node if doesn't exist
 */
trie trie_trav(trie root, const char * str, int no_create)
{
	int c;
	while (root) {
		if ((c = str[0]) == '\0') {
			if (!root->eow && no_create) return 0;
			break;
		}
		if (! (c = chr_idx[c]) ) {
			str++;
			continue;
		}

		if (!root->next[c]) {
			if (no_create) return 0;
			root->next[c] = trie_new();
		}
		root = root->next[c];
		str++;
	}
	return root;
}

/*  complete traversal of whole tree, calling callback at each end of word node.
 *  similar method can be used to free nodes, had we wanted to do that.
 */
int trie_all(trie root, char path[], int depth, int (*callback)(char *))
{
	int i;
	if (root->eow && !callback(path)) return 0;

	for (i = 1; i < sizeof(chr_legal); i++) {
		if (!root->next[i]) continue;

		path[depth] = idx_chr[i];
		path[depth + 1] = '\0';
		if (!trie_all(root->next[i], path, depth + 1, callback))
			return 0;
	}
	return 1;
}

void add_index(trie root, const char *word, const char *fname)
{
	trie x = trie_trav(root, word, 0);
	x->eow = 1;

	if (!x->next[FNAME])
		x->next[FNAME] = trie_new();
	x = trie_trav(x->next[FNAME], fname, 0);
	x->eow = 1;
}

int print_path(char *path)
{
	printf(" %s", path);
	return 1;
}

/*  pretend we parsed text files and got lower cased words: dealing     *
 *  with text file is a whole other animal and would make code too long */
const char *files[] = { "f1.txt", "source/f2.txt", "other_file" };
const char *text[][5] ={{ "it", "is", "what", "it", "is" },
		        { "what", "is", "it", 0 },
		        { "it", "is", "a", "banana", 0 }};

trie init_tables()
{
	int i, j;
	trie root = trie_new();
	for (i = 0; i < sizeof(chr_legal); i++) {
		chr_idx[(int)chr_legal[i]] = i + 1;
		idx_chr[i + 1] = chr_legal[i];
	}

/* Enable USE_ADVANCED_FILE_HANDLING to use advanced file handling.
 * You need to have files named like above files[], with words in them
 * like in text[][].  Case doesn't matter (told you it's advanced).
 */
#define USE_ADVANCED_FILE_HANDLING 0
#if USE_ADVANCED_FILE_HANDLING
	void read_file(const char * fname) {
		char cmd[1024];
		char word[1024];
		sprintf(cmd, "perl -p -e 'while(/(\\w+)/g) {print lc($1),\"\\n\"}' %s", fname);
		FILE *in = popen(cmd, "r");
		while (!feof(in)) {
			fscanf(in, "%1000s", word);
			add_index(root, word, fname);
		}
		pclose(in);
	};

	read_file("f1.txt");
	read_file("source/f2.txt");
	read_file("other_file");
#else
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 5; j++) {
			if (!text[i][j]) break;
			add_index(root, text[i][j], files[i]);
		}
	}
#endif /*USE_ADVANCED_FILE_HANDLING*/

	return root;
}

void search_index(trie root, const char *word)
{
	char path[1024];
	printf("Search for \"%s\": ", word);
	trie found = find_word(root, word);

	if (!found) printf("not found\n");
	else {
		trie_all(found->next[FNAME], path, 0, print_path);
		printf("\n");
	}
}

int main()
{
	trie root = init_tables();

	search_index(root, "what");
	search_index(root, "is");
	search_index(root, "banana");
	search_index(root, "boo");
	return 0;
}
