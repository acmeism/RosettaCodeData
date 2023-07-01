/*
 * RosettaCode: Substring, C89, Unicode
 *
 * In this task display a substring: starting from n characters in and of m
 * length; starting from n characters in, up to the end of the string; whole
 * string minus last character; starting from a known character within the
 * string and of m length; starting from a known substring within the string
 * and of m length.
 *
 * This example program DOES NOT make substrings. The program simply displays
 * certain parts of the input string.
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Put all characters from string to standard output AND write newline.
 * BTW, _putws may not be avaliable.
 */
void put(wchar_t* string)
{
    while(*string)
        putwchar(*string++);
    putwchar(L'\n');
}

/*
 * Put no more than m characters from string to standard output AND newline.
 */
void putm(wchar_t* string, size_t m)
{
    while(*string && m--)
        putwchar(*string++);
    putwchar(L'\n');
}

int main(void)
{
    wchar_t string[] =
        L"Programs for other encodings (such as 8-bit ASCII).";

    int n = 3;
    int m = 4;
    wchar_t knownCharacter = L'(';
    wchar_t knownSubstring[] = L"encodings";

    putm(string+n-1,m);
    put (string+n+1);
    putm(string, wcslen(string)-1);
    putm(wcschr(string, knownCharacter), m );
    putm(wcsstr(string, knownSubstring), m );

    return EXIT_SUCCESS;
}
