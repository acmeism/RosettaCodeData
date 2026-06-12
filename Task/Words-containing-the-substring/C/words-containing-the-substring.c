#include <stdio.h>
#include <string.h>

int main() {
    char word[128];
    FILE *f = fopen("unixdict.txt","r");
    if (!f) {
        fprintf(stderr, "Cannot open unixdict.txt\n");
        return -1;
    }
    while (!feof(f)) {
        fgets(word, sizeof(word), f);
        // fgets() includes the \n character, so we need to test
        // for a length of 12 (11 letters plus the newline)
        if (strlen(word) > 12 && strstr(word,"the"))
            printf("%s",word);
    }
    fclose(f);
    return 0;
}
