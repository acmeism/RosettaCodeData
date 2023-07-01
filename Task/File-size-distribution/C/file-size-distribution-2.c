#include <ftw.h>
#include <locale.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static const uintmax_t sizes[] = {
    0, 1000, 10000, 100000, 1000000, 10000000,
    100000000, 1000000000, 10000000000
};
static const size_t nsizes = sizeof(sizes)/sizeof(sizes[0]);
static uintmax_t count[nsizes + 1] = { 0 };
static uintmax_t files = 0;
static uintmax_t total_size = 0;

static int callback(const char* file, const struct stat* sp, int flag) {
    if (flag == FTW_F) {
        uintmax_t file_size = sp->st_size;
        ++files;
        total_size += file_size;
        size_t index = 0;
        for (; index < nsizes && sizes[index] < file_size; ++index);
        ++count[index];
    } else if (flag == FTW_DNR) {
        fprintf(stderr, "Cannot read directory %s.\n", file);
    }
    return 0;
}

int main(int argc, char** argv) {
    setlocale(LC_ALL, "");
    const char* directory = argc > 1 ? argv[1] : ".";
    if (ftw(directory, callback, 512) != 0) {
        perror(directory);
        return EXIT_FAILURE;
    }
    printf("File size distribution for '%s':\n", directory);
    for (size_t i = 0; i <= nsizes; ++i) {
        if (i == nsizes)
            printf("> %'lu", sizes[i - 1]);
        else
            printf("%'16lu", sizes[i]);
        printf(" bytes: %'lu\n", count[i]);
    }
    printf("Number of files: %'lu\n", files);
    printf("Total file size: %'lu\n", total_size);
    return EXIT_SUCCESS;
}
