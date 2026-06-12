#include <stdio.h>
#include <string.h>

int match(const char *word) {
    const char *a = strchr(word, 'a');
    const char *b = strchr(word, 'b');
    const char *c = strchr(word, 'c');
    return a && b && c && a<b && b<c;
}

int main() {
    char word[80];
    FILE *file = fopen("unixdict.txt", "r");
    if (!file) {
        fprintf(stderr, "Cannot open unixdict.txt");
        return -1;
    }

    while (!feof(file)) {
        fgets(word, sizeof(word), file);
        if(match(word)) printf("%s", word);
    }
    return 0;
}
