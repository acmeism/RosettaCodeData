#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main()
{
	FILE * fp;
	char * line = NULL;
	size_t len = 0;
	ssize_t read;

	fp = fopen("fasta.txt", "r");
	if (fp == NULL)
		exit(EXIT_FAILURE);

	int state = 0;
	while ((read = getline(&line, &len, fp)) != -1) {
		/* Delete trailing newline */
		if (line[read - 1] == '\n')
			line[read - 1] = 0;
		/* Handle comment lines*/
		if (line[0] == '>') {
			if (state == 1)
				printf("\n");
			printf("%s: ", line+1);
			state = 1;
		} else {
			/* Print everything else */
			printf("%s", line);
		}
	}
	printf("\n");

	fclose(fp);
	if (line)
		free(line);
	exit(EXIT_SUCCESS);
}
