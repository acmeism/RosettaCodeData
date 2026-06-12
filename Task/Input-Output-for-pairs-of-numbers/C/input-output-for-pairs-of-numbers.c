#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	int i, n, a, b, *f;
	scanf("%d", &n);
	f = malloc(sizeof(*f) * n);

	for (i = 0; i < n; i++) {
		if (2 != scanf("%d %d", &a, &b))
			abort();
		f[i] = a + b;
	}

	for (i = 0; i < n; i++)
		printf("%d\n", f[i]);

	return 0;
}
