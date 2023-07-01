#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

bool is_palindrome(const char* str) {
    size_t n = strlen(str);
    for (size_t i = 0; i + 1 < n; ++i, --n) {
        if (str[i] != str[n - 1])
            return false;
    }
    return true;
}

int main() {
    time_t timestamp = time(0);
    const int seconds_per_day = 24*60*60;
    int count = 15;
    char str[32];
    printf("Next %d palindrome dates:\n", count);
    for (; count > 0; timestamp += seconds_per_day) {
        struct tm* ptr = gmtime(&timestamp);
        strftime(str, sizeof(str), "%Y%m%d", ptr);
        if (is_palindrome(str)) {
            strftime(str, sizeof(str), "%F", ptr);
            printf("%s\n", str);
            --count;
        }
    }
    return 0;
}
