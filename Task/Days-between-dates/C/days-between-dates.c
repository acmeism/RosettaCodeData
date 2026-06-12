#define _XOPEN_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int
main(void)
{
	char buf[64];
	struct tm tp;
	char *p;
	time_t t1, t2, diff;

	memset(buf, 0, sizeof(buf));
	memset(&tp, 0, sizeof(tp));

	/* read the first date */
	printf("Enter the first date (yyyy-mm-dd): ");
	fflush(stdout);
	p = fgets(buf, sizeof(buf), stdin);
	if (p == NULL) {
		fprintf(stderr, "No input detected\n");
		return EXIT_FAILURE;
	}
	p = strptime(buf, "%Y-%m-%d", &tp);
	if (p == NULL) {
		fprintf(stderr, "Unable to parse time\n");
		return EXIT_FAILURE;
	}
	t1 = mktime(&tp);

	/* read the second date */
	printf("Enter the second date (yyyy-mm-dd): ");
	p = fgets(buf, sizeof(buf), stdin);
	if (p == NULL) {
		fprintf(stderr, "No input detected\n");
		return EXIT_FAILURE;
	}
	p = strptime(buf, "%Y-%m-%d", &tp);
	if (p == NULL) {
		fprintf(stderr, "Unable to parse time\n");
		return EXIT_FAILURE;
	}
	t2 = mktime(&tp);

	/* work out the difference in days */
	if (t2 > t1)
		diff = t2 - t1;
	else
		diff = t1 - t2;

	printf("%ld days difference\n", diff/(60*60*24));

	return EXIT_SUCCESS;
}
