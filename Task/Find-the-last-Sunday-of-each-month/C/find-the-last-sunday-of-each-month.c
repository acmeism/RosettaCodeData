#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void last_sunday(struct tm *res, unsigned year, unsigned mon)
{
	time_t sec;

	*res = (struct tm){
		.tm_year = year + mon / 12,
		.tm_mon = mon % 12,
		.tm_hour = 12,
		.tm_isdst = -1
	};
	sec = mktime(res);
	sec -= res->tm_wday * 86400;
	*res = *localtime(&sec);
}

int main(int argc, char *argv[])
{
	struct tm date;
	char str[12];
	unsigned m, y;

	if (argc < 2)
		return 1;
	y = strtoul(argv[1], NULL, 0) - 1900;
	for (m = 1; m <= 12; ++m) {
		last_sunday(&date, y, m);
		strftime(str, sizeof str, "%F", &date);
		puts(str);
	}

	return 0;
}
