#include <err.h>	/* err */
#include <stdio.h>	/* fopen, fgetln, fputs, fwrite */

/*
 * Read a file line by line.
 * http://rosettacode.org/wiki/Read_a_file_line_by_line
 */
int
main()
{
	FILE *f;
	size_t len;
	char *line;

	f = fopen("foobar.txt", "r");
	if (f == NULL)
		err(1, "foobar.txt");

	/*
	 * This loop reads each line.
	 * Remember that line is not a C string.
	 * There is no terminating '\0'.
	 */
	while (line = fgetln(f, &len)) {
		/*
		 * Do something with line.
		 */
		fputs("LINE: ", stdout);
		fwrite(line, len, 1, stdout);
	}
	if (!feof(f))
		err(1, "fgetln");

	return 0;
}
