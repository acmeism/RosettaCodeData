#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

typedef enum {
    whole_word = 1,
    overkill = 2,
    case_insensitive = 4
} redact_options;

bool is_word_char(char ch) {
    return ch == '-' || isalpha((unsigned char)ch);
}

// Performs in-place redaction of the target with the specified options.
void redact(char* text, const char* target, redact_options options) {
    size_t target_length = strlen(target);
    if (target_length == 0)
        return;
    char* start = text;
    char* end = text + strlen(text);
    while (start < end) {
        // NB: strcasestr is a non-standard extension. It's similar to the
        // standard strstr function, but case-insensitive.
        char* str = (options & case_insensitive) ? strcasestr(start, target)
                        : strstr(start, target);
        if (str == NULL)
            break;
        char* word_start = str;
        char* word_end = str + target_length;
        if (options & (overkill | whole_word)) {
            while (word_start > start && is_word_char(*(word_start - 1)))
                --word_start;
            while (word_end < end && is_word_char(*word_end))
                ++word_end;
        }
        if (!(options & whole_word) ||
            (word_start == str && word_end == str + target_length))
            memset(word_start, 'X', word_end - word_start);
        start = word_end;
    }
}

void do_basic_test(const char* target, redact_options options) {
    char text[] = "Tom? Toms bottom tomato is in his stomach while playing the "
        "\"Tom-tom\" brand tom-toms. That's so tom.";
    redact(text, target, options);
    printf("[%c|%c|%c]: %s\n", (options & whole_word) ? 'w' : 'p',
           (options & case_insensitive) ? 'i' : 's',
           (options & overkill) ? 'o' : 'n', text);
}

void do_basic_tests(const char* target) {
    printf("Redact '%s':\n", target);
    do_basic_test(target, whole_word);
    do_basic_test(target, whole_word | case_insensitive);
    do_basic_test(target, 0);
    do_basic_test(target, case_insensitive);
    do_basic_test(target, overkill);
    do_basic_test(target, case_insensitive | overkill);
}

int main() {
    do_basic_tests("Tom");
    printf("\n");
    do_basic_tests("tom");
    return 0;
}
