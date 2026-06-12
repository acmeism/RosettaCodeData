char input[] =	"top1    des1 ip1 ip2\n"
		"top2    des1 ip2 ip3\n"
		"ip1     extra1 ip1a ipcommon\n"
		"ip2     ip2a ip2b ip2c ipcommon\n"
		"des1    des1a des1b des1c\n"
		"des1a   des1a1 des1a2\n"
		"des1c   des1c1 extra1\n";

...
int find_name(item base, int len, const char *name)
{
	int i;
	for (i = 0; i < len; i++)
		if (!strcmp(base[i].name, name)) return i;
	return -1;
}

int depends_on(item base, int n1, int n2)
{
	int i;
	if (n1 == n2) return 1;
	for (i = 0; i < base[n1].n_deps; i++)
		if (depends_on(base, base[n1].deps[i], n2)) return 1;
	return 0;
}

void compile_order(item base, int n_items, int *top, int n_top)
{
	int i, j, lvl;
	int d = 0;
	printf("Compile order for:");
	for (i = 0; i < n_top; i++) {
		printf(" %s", base[top[i]].name);
		if (base[top[i]].depth > d)
			d = base[top[i]].depth;
	}
	printf("\n");

	for (lvl = 1; lvl <= d; lvl ++) {
		printf("level %d:", lvl);
		for (i = 0; i < n_items; i++) {
			if (base[i].depth != lvl) continue;
			for (j = 0; j < n_top; j++) {
				if (depends_on(base, top[j], i)) {
					printf(" %s", base[i].name);
					break;
				}
			}
		}
		printf("\n");
	}
	printf("\n");
}

int main()
{
	int i, n, bad = -1;
	item items;
	n = parse_input(&items);

	for (i = 0; i < n; i++)
		if (!items[i].depth && get_depth(items, i, bad) < 0) bad--;

	int top[3];
	top[0] = find_name(items, n, "top1");
	top[1] = find_name(items, n, "top2");
	top[2] = find_name(items, n, "ip1");

	compile_order(items, n, top, 1);
	compile_order(items, n, top + 1, 1);
	compile_order(items, n, top, 2);
	compile_order(items, n, top + 2, 1);

	return 0;
}
