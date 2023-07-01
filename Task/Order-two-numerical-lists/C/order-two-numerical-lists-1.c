int list_cmp(int *a, int la, int *b, int lb)
{
	int i, l = la;
	if (l > lb) l = lb;
	for (i = 0; i < l; i++) {
		if (a[i] == b[i]) continue;
		return (a[i] > b[i]) ? 1 : -1;
	}
	if (la == lb) return 0;
	return la > lb ? 1 : -1;
}
