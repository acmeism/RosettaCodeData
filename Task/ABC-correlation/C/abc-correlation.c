#include <stdbool.h>
#include <stdio.h>

// Example strings to pass to count_abc
const char* EXAMPLES[] = {
    "abc",
    "aabbcc",
    "abbc",
    "a",
    "",
    "the quick brown fox jumps over the lazy dog",
    "rosetta code",
    "hello, world!",
};

// Return true if the given string contains an equal number of 'a', 'b' and 'c'
// characters (case-sensitive). Otherwise, return false.
bool count_abc(const char* str)
{
    int aCount = 0, bCount = 0, cCount = 0;
    for (const char* curr = str; *curr != '\0'; curr++)
    {
        if (*curr == 'a')
            ++aCount;
        else if (*curr == 'b')
            ++bCount;
        else if (*curr == 'c')
            ++cCount;
    }
    return aCount == bCount && bCount == cCount;
}

int main(void)
{
    // Number of character pointers (strings) in the EXAMPLES array
    const size_t num_examples = sizeof(EXAMPLES) / sizeof(const char*);
    for (size_t i = 0; i < num_examples; i++)
    {
        if (count_abc(EXAMPLES[i]))
        {
            printf("'%s' is an ABC string.\n", EXAMPLES[i]);
        }
        else
        {
            printf("'%s' is NOT an ABC string.\n", EXAMPLES[i]);
        }
    }
    return 0;
}

