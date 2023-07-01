/**
 * An example for RossetaCode - an example of string operation with wchar_t and
 * with old 8-bit characters. Anyway, it seem that C is not very UTF-8 friendly,
 * thus C# or C++ may be a better choice.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * The wide character version of the program is compiled if WIDE_CHAR is defined
 */
#define WIDE_CHAR

#ifdef WIDE_CHAR
#define CHAR wchar_t
#else
#define CHAR char
#endif

/**
 * Find a character different from the preceding characters in the given string.
 *
 * @param s the given string, NULL terminated.
 *
 * @return the pointer to the occurence of the different character
 *         or a pointer to NULL if all characters in the string
 *         are exactly the same.
 *
 * @notice This function return a pointer to NULL also for empty strings.
 *         Returning NULL-or-CHAR would not enable to compute the position
 *         of the non-matching character.
 *
 * @warning This function compare characters (single-bytes, unicode etc.).
 *          Therefore this is not designed to compare bytes. The NULL character
 *          is always treated as the end-of-string marker, thus this function
 *          cannot be used to scan strings with NULL character inside string,
 *          for an example "aaa\0aaa\0\0".
 */
const CHAR* find_different_char(const CHAR* s)
{
    /* The code just below is almost the same regardles
       char or wchar_t is used. */

    const CHAR c = *s;
    while (*s && c == *s)
    {
        s++;
    }
    return s;
}

/**
 * Apply find_different_char function to a given string and output the raport.
 *
 * @param s the given NULL terminated string.
 */
void report_different_char(const CHAR* s)
{
#ifdef WIDE_CHAR
    wprintf(L"\n");
    wprintf(L"string: \"%s\"\n", s);
    wprintf(L"length: %d\n", wcslen(s));
    const CHAR* d = find_different_char(s);
    if (d)
    {
        /*
         * We have got the famous pointers arithmetics and we can compute
         * difference of pointers pointing to the same array.
         */
        wprintf(L"character '%wc' (%#x) at %d\n", *d, *d, (int)(d - s));
    }
    else
    {
        wprintf(L"all characters are the same\n");
    }
    wprintf(L"\n");
#else
    putchar('\n');
    printf("string: \"%s\"\n", s);
    printf("length: %d\n", strlen(s));
    const CHAR* d = find_different_char(s);
    if (d)
    {
        /*
         * We have got the famous pointers arithmetics and we can compute
         * difference of pointers pointing to the same array.
         */
        printf("character '%c' (%#x) at %d\n", *d, *d, (int)(d - s));
    }
    else
    {
        printf("all characters are the same\n");
    }
    putchar('\n');
#endif
}

/* There is a wmain function as an entry point when argv[] points to wchar_t */

#ifdef WIDE_CHAR
int wmain(int argc, wchar_t* argv[])
#else
int main(int argc, char* argv[])
#endif
{
    if (argc < 2)
    {
        report_different_char(L"");
        report_different_char(L"   ");
        report_different_char(L"2");
        report_different_char(L"333");
        report_different_char(L".55");
        report_different_char(L"tttTTT");
        report_different_char(L"4444 444k");
    }
    else
    {
        report_different_char(argv[1]);
    }

    return EXIT_SUCCESS;
}
