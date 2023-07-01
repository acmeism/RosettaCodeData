#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    char *lw, *lt;
    fp = fopen("data.txt", "r");
    if (fp == NULL) {
        printf("Unable to open file\n");
        exit(1);
    }
    printf("Those earthquakes with a magnitude > 6.0 are:\n\n");
    while ((read = getline(&line, &len, fp)) != EOF) {
        if (read < 2) continue;   /* ignore blank lines */
        lw = strrchr(line, ' ');  /* look for last space */
        lt = strrchr(line, '\t'); /* look for last tab */
        if (!lw && !lt) continue; /* ignore lines with no whitespace */
        if (lt > lw) lw = lt;     /* lw points to last space or tab */
        if (atof(lw + 1) > 6.0) printf("%s", line);
    }
    fclose(fp);
    if (line) free(line);
    return 0;
}
