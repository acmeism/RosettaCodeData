#include <iostream>

const char *REASON = "She swallowed the %s to catch the %s\n";
const char *CREATURES[] = { "fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse" };
const char *COMMENTS[] = {
    "I don't know why she swallowed that fly.\nPerhaps she'll die\n",
    "That wiggled and jiggled and tickled inside her",
    "How absurd, to swallow a bird",
    "Imagine that. She swallowed a cat",
    "What a hog to swallow a dog",
    "She just opened her throat and swallowed that goat",
    "I don't know how she swallowed that cow",
    "She's dead of course"
};

int main() {
    auto max = sizeof(CREATURES) / sizeof(char*);
    for (size_t i = 0; i < max; ++i) {
        std::cout << "There was an old lady who swallowed a " << CREATURES[i] << '\n';
        std::cout << COMMENTS[i] << '\n';
        for (int j = i; j > 0 && i < max - 1; --j) {
            printf(REASON, CREATURES[j], CREATURES[j - 1]);
            if (j == 1) {
                std::cout << COMMENTS[j - 1] << '\n';
            }
        }
    }

    return 0;
}
