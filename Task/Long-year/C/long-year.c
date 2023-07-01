#include <stdio.h>
#include <math.h>

// https://webspace.science.uu.nl/~gent0113/calendar/isocalendar.htm

int p(int year) {
	return (int)((double)year + floor(year/4) - floor(year/100) + floor(year/400)) % 7;
}

int is_long_year(int year) {
	return p(year) == 4 || p(year - 1) == 3;
}

void print_long_years(int from, int to) {
	for (int year = from; year <= to; ++year) {
		if (is_long_year(year)) {
			printf("%d ", year);
		}
	}
}

int main() {

	printf("Long (53 week) years between 1800 and 2100\n\n");
	print_long_years(1800, 2100);
	printf("\n");
	return 0;
}
