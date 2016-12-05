#include <stdio.h>
#include <stdlib.h>
#include <libgen.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

int main (int argc, char **argv) {
    char *str, *s;
    struct stat statBuf;

    if (argc != 2) {
        fprintf (stderr, "usage: %s <path>\n", basename (argv[0]));
        exit (1);
    }
    s = argv[1];
    while ((str = strtok (s, "/")) != NULL) {
        if (str != s) {
            str[-1] = '/';
        }
        if (stat (argv[1], &statBuf) == -1) {
            mkdir (argv[1], 0);
        } else {
            if (! S_ISDIR (statBuf.st_mode)) {
                fprintf (stderr, "couldn't create directory %s\n", argv[1]);
                exit (1);
            }
        }
        s = NULL;
    }
    return 0;
}
