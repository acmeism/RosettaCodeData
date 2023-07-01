#include <stdio.h>
static char const *animals[] = {
    "fly",
    "spider",
    "bird",
    "cat",
    "dog",
    "goat",
    "cow",
    "horse"
};
static char const *verses[]  = {
    "I don't know why she swallowed that fly.\nPerhaps she'll die\n",
    "That wiggled and jiggled and tickled inside her",
    "How absurd, to swallow a bird",
    "Imagine that. She swallowed a cat",
    "What a hog to swallow a dog",
    "She just opened her throat and swallowed that goat",
    "I don't know how she swallowed that cow",
    "She's dead of course"
};

#define LEN(ARR) (sizeof ARR / sizeof *ARR)

int main(void)
{
    for (size_t i = 0; i < LEN(animals); i++) {
        printf("There was an old lady who swallowed a %s\n%s\n", animals[i], verses[i]);
        for (size_t j = i; j > 0 && i < LEN(animals) - 1; j--) {
            printf("She swallowed the %s to catch the %s\n", animals[j], animals[j-1]);
            if (j == 1) {
                printf("%s\n", verses[0]);
            }
        }
    }
}
