#include <stdio.h>
#include <string.h>

// returns count of non-overlapping occurrences of 'sub' in 'str'
int countSubstring(const char *str, const char *sub)
{
    int length = strlen(sub);
    if (length == 0) return 0;
    int count = 0;
    for (str = strstr(str, sub); str; str = strstr(str + length, sub))
        ++count;
    return count;
}

int main()
{
    printf("%d\n", countSubstring("the three truths", "th"));
    printf("%d\n", countSubstring("ababababab", "abab"));
    printf("%d\n", countSubstring("abaabba*bbaba*bbab", "a*b"));

    return 0;
}
