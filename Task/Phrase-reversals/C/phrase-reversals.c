#include <stdio.h>
#include <string.h>

/* The functions used are destructive, so after each call the string needs
 * to be copied over again. One could easily allocate new strings as
 * required, but this way allows the caller to manage memory themselves */

char* reverse_section(char *s, size_t length)
{
    if (length == 0) return s;

    size_t i; char temp;
    for (i = 0; i < length / 2 + 1; ++i)
        temp = s[i], s[i] = s[length - i], s[length - i] = temp;
    return s;
}

char* reverse_words_in_order(char *s, char delim)
{
    if (!strlen(s)) return s;

    size_t i, j;
    for (i = 0; i < strlen(s) - 1; ++i) {
        for (j = 0; s[i + j] != 0 && s[i + j] != delim; ++j)
            ;
        reverse_section(s + i, j - 1);
        s += j;
    }
    return s;
}

char* reverse_string(char *s)
{
    return strlen(s) ? reverse_section(s, strlen(s) - 1) : s;
}

char* reverse_order_of_words(char *s, char delim)
{
    reverse_string(s);
    reverse_words_in_order(s, delim);
    return s;
}

int main(void)
{
    char str[]    = "rosetta code phrase reversal";
    size_t lenstr = sizeof(str) / sizeof(str[0]);
    char scopy[lenstr];
    char delim = ' ';

    /* Original String */
    printf("Original:       \"%s\"\n", str);

    /* Reversed string */
    strncpy(scopy, str, lenstr);
    reverse_string(scopy);
    printf("Reversed:       \"%s\"\n", scopy);

    /* Reversed words in string */
    strncpy(scopy, str, lenstr);
    reverse_words_in_order(scopy, delim);
    printf("Reversed words: \"%s\"\n", scopy);

    /* Reversed order of words in string */
    strncpy(scopy, str, lenstr);
    reverse_order_of_words(scopy, delim);
    printf("Reversed order: \"%s\"\n", scopy);

    return 0;
}
