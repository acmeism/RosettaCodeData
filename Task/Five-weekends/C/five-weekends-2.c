#include <stdio.h>
#include <string.h>

int check_month(int y, int m)
{
	char buf[1024], *ptr;
	int bytes, *a = &m;

	sprintf(buf, "ncal -m %d -M %d", m, y);
	FILE *fp = popen(buf, "r");
	if (!fp) return -1;

	bytes = fread(buf, 1, 1024, fp);
	fclose(fp);
	buf[bytes] = 0;

#define check_day(x) \
	ptr = strstr(buf, x);\
	if (5 != sscanf(ptr, x" %d %d %d %d %d", a, a, a, a, a)) return 0

	check_day("Fr");
	check_day("Sa");
	check_day("Su");
	return 1;
}

int main()
{
	int y, m, cnt = 0;
	for (y = 1900; y <= 2100; y++) {
		for (m = 1; m <= 12; m++) {
			if (check_month(y, m) <= 0) continue;
			printf("%d-%02d ", y, m);
			if (++cnt % 16 == 0) printf("\n");
		}
	}
	printf("\nTotal: %d\n", cnt);

	return 0;
}
