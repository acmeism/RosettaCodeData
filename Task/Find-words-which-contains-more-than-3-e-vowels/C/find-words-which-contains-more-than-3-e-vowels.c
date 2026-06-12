#include <stdio.h>
#define SIZE 256

int check(char *word) {
    int e = 0, ok = 1;
    for(; *word && ok; word++) {
        switch(*word) {
            case 'a':
            case 'i':
            case 'o':
            case 'u': ok = 0; break;
            case 'e': e++;
        }
    }

    return ok && e > 3;
}

int main() {
    FILE *f;
    char line[SIZE];

    if (!(f = fopen("unixdict.txt", "r"))) {
        fprintf(stderr, "Cannot open unixdict.txt\n");
        return 1;
    }

    while (!feof(f)) {
        fgets(line, SIZE, f);
        if (check(line)) printf("%s", line);
    }

    fclose(f);
    return 0;
}
