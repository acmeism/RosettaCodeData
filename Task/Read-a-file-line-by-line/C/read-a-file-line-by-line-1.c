/*
 * Read (and write) the standard input file
 * line-by-line. This version is for ASCII
 * encoded text files.
 */
#include <stdio.h>

/*
 * BUFSIZE is a max size of line plus 1.
 *
 * It would be nice to dynamically allocate  bigger buffer for longer lines etc.
 * - but this example is as simple as possible. Dynamic buffer allocation from
 * the heap may not be a good idea as it seems, because it can cause memory
 * segmentation in embeded systems.
 */
#define BUFSIZE 1024

int main(void)
{
    static char buffer[BUFSIZE];

    /*
     * Never use gets() instead fgets(), because gets()
     * is a really unsafe function.
     */
    while (fgets(buffer, BUFSIZE, stdin))
        puts(buffer);

    return 0;
}
