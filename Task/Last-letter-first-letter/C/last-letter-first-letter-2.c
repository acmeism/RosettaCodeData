#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define forall(i, n) for (int i = 0; i < n; i++)
typedef struct edge { char s, e, *str; struct edge *lnk; } edge;
typedef struct { edge* e[26]; int nin, nout, in[26], out[26];} node;
typedef struct { edge *e, *tail; int len, has[26]; } chain;

node nodes[26];
edge *names, **tmp;
int n_names;

/* add edge to graph */
void store_edge(edge *g)
{
	if (!g) return;
	int i = g->e, j = g->s;
	node *n = nodes + j;

	g->lnk = n->e[i];

	n->e[i] = g, n->out[i]++, n->nout++;
	n = nodes + i, n->in[j]++, n->nin++;
}

/* unlink an edge between nodes i and j, and return the edge */
edge* remove_edge(int i, int j)
{
	node *n = nodes + i;
	edge *g = n->e[j];
	if (g) {
		n->e[j] = g->lnk;
		g->lnk = 0;
		n->out[j]--, n->nout--;

		n = nodes + j;
		n->in[i]--;
		n->nin--;
	}
	return g;
}

void read_names()
{
	FILE *fp = fopen("poke646", "rt");
	int i, len;
	char *buf;
	edge *p;

	if (!fp) abort();

	fseek(fp, 0, SEEK_END);
	len = ftell(fp);
	buf = malloc(len + 1);
	fseek(fp, 0, SEEK_SET);
	fread(buf, 1, len, fp);
	fclose(fp);

	buf[len] = 0;
	for (n_names = i = 0; i < len; i++)
		if (isspace(buf[i]))
			buf[i] = 0, n_names++;

	if (buf[len-1]) n_names++;

	memset(nodes, 0, sizeof(node) * 26);
	tmp = calloc(n_names, sizeof(edge*));

	p = names = malloc(sizeof(edge) * n_names);
	for (i = 0; i < n_names; i++, p++) {
		if (i)	p->str = names[i-1].str + len + 1;
		else	p->str = buf;

		len = strlen(p->str);
		p->s = p->str[0] - 'a';
		p->e = p->str[len-1] - 'a';
		if (p->s < 0 || p->s >= 26 || p->e < 0 || p->e >= 26) {
			printf("bad name %s: first/last char must be letter\n",
				p->str);
			abort();
		}
	}
	printf("read %d names\n", n_names);
}

void show_chain(chain *c)
{
	printf("%d:", c->len);
	for (edge * e = c->e; e || !putchar('\n'); e = e->lnk)
		printf(" %s", e->str);
}

/* Which next node has most enter or exit edges. */
int widest(int n, int out)
{
	if (nodes[n].out[n]) return n;

	int mm = -1, mi = -1;
	forall(i, 26) {
		if (out) {
			if (nodes[n].out[i] && nodes[i].nout > mm)
				mi = i, mm = nodes[i].nout;
		} else {
			if (nodes[i].out[n] && nodes[i].nin > mm)
				mi = i, mm = nodes[i].nin;
		}
	}

	return mi;
}

void insert(chain *c, edge *e)
{
	e->lnk = c->e;
	if (!c->tail) c->tail = e;
	c->e = e;
	c->len++;
}

void append(chain *c, edge *e)
{
	if (c->tail) c->tail->lnk = e;
	else c->e = e;
	c->tail = e;
	c->len++;
}

edge * shift(chain *c)
{
	edge *e = c->e;
	if (e) {
		c->e = e->lnk;
		if (!--c->len) c->tail = 0;
	}
	return e;
}

chain* make_chain(int s)
{
	chain *c = calloc(1, sizeof(chain));
	
	/* extend backwards */
	for (int i, j = s; (i = widest(j, 0)) >= 0; j = i)
		insert(c, remove_edge(i, j));

	/* extend forwards */
	for (int i, j = s; (i = widest(j, 1)) >= 0; j = i)
		append(c, remove_edge(j, i));

	for (int step = 0;; step++) {
		edge *e = c->e;

		for (int i = 0; i < step; i++)
			if (!(e = e->lnk)) break;
		if (!e) return c;

		int n = 0;
		for (int i, j = e->s; (i = widest(j, 0)) >= 0; j = i) {
			if (!(e = remove_edge(i, j))) break;
			tmp[n++] = e;
		}

		if (n > step) {
			forall(i, step) store_edge(shift(c));
			forall(i, n) insert(c, tmp[i]);
			step = -1;
		} else while (--n >= 0)
			store_edge(tmp[n]);
	}
	return c;
}

int main(void)
{
	int best = 0;
	read_names();

	forall(i, 26) {
		/* rebuild the graph */
		memset(nodes, 0, sizeof(nodes));
		forall(j, n_names) store_edge(names + j);

		/* make a chain from node i */
		chain *c = make_chain(i);
		if (c->len > best) {
			show_chain(c);
			best = c->len;
		}
		free(c);
	}

	printf("longest found: %d\n", best);
	return 0;
}
