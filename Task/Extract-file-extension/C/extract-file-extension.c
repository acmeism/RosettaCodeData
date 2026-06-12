#include <assert.h>
#include <ctype.h>
#include <string.h>
#include <stdio.h>

/* Returns a pointer to the extension of 'string'.
 * If no extension is found, returns a pointer to the end of 'string'. */
char* file_ext(const char *string)
{
    assert(string != NULL);
    char *ext = strrchr(string, '.');

    if (ext == NULL)
        return (char*) string + strlen(string);

    for (char *iter = ext + 1; *iter != '\0'; iter++) {
        if (!isalnum((unsigned char)*iter))
            return (char*) string + strlen(string);
    }

    return ext;
}

int main(void)
{
    const char *testcases[][2] = {
        {"http://example.com/download.tar.gz", ".gz"},
        {"CharacterModel.3DS", ".3DS"},
        {".desktop", ".desktop"},
        {"document", ""},
        {"document.txt_backup", ""},
        {"/etc/pam.d/login", ""}
    };

    int exitcode = 0;
    for (size_t i = 0; i < sizeof(testcases) / sizeof(testcases[0]); i++) {
        const char *ext = file_ext(testcases[i][0]);
        if (strcmp(ext, testcases[i][1]) != 0) {
            fprintf(stderr, "expected '%s' for '%s', got '%s'\n",
                testcases[i][1], testcases[i][0], ext);
            exitcode = 1;
        }
    }
    return exitcode;
}
