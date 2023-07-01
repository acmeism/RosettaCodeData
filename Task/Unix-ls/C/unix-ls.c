#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

int cmpstr(const void *a, const void *b)
{
    return strcmp(*(const char**)a, *(const char**)b);
}

int main(void)
{
    DIR *basedir;
    char path[PATH_MAX];
    struct dirent *entry;
    char **dirnames;
    int diralloc = 128;
    int dirsize  = 0;

    if (!(dirnames = malloc(diralloc * sizeof(char*)))) {
        perror("malloc error:");
        return 1;
    }

    if (!getcwd(path, PATH_MAX)) {
        perror("getcwd error:");
        return 1;
    }

    if (!(basedir = opendir(path))) {
        perror("opendir error:");
        return 1;
    }

    while ((entry = readdir(basedir))) {
        if (dirsize >= diralloc) {
            diralloc *= 2;
            if (!(dirnames = realloc(dirnames, diralloc * sizeof(char*)))) {
                perror("realloc error:");
                return 1;
            }
        }
        dirnames[dirsize++] = strdup(entry->d_name);
    }

    qsort(dirnames, dirsize, sizeof(char*), cmpstr);

    int i;
    for (i = 0; i < dirsize; ++i) {
        if (dirnames[i][0] != '.') {
            printf("%s\n", dirnames[i]);
        }
    }

    for (i = 0; i < dirsize; ++i)
        free(dirnames[i]);
    free(dirnames);
    closedir(basedir);
    return 0;
}
