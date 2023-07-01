/*
 * Program seconds2string, C89 version.
 *
 * Read input from argv[1] or stdin, write output to stdout.
 */

#define _CRT_SECURE_NO_WARNINGS /* unlocks printf in Microsoft Visual Studio */

#include <stdio.h>
#include <stdlib.h>

/*
 * Converting the number of seconds in a human-readable string.
 * It is worth noting that direct output to stdout would be even simpler.
 */
char* seconds2string(unsigned long seconds)
{
    int i;

    const unsigned long s =  1;
    const unsigned long m = 60 * s;
    const unsigned long h = 60 * m;
    const unsigned long d = 24 * h;
    const unsigned long w =  7 * d;

    const unsigned long coeff[5] = { w, d, h, m, s };
    const char units[5][4] = { "wk", "d", "hr", "min", "sec" };

    static char buffer[256];
    char* ptr = buffer;

    for ( i = 0; i < 5; i++ )
    {
        unsigned long value;
        value   = seconds / coeff[i];
        seconds = seconds % coeff[i];
        if ( value )
        {
            if ( ptr != buffer )
                ptr += sprintf(ptr, ", ");
            ptr += sprintf(ptr,"%lu %s",value,units[i]);
        }
    }

    return buffer;
}

/*
 * Main function for seconds2string program.
 */
int main(int argc, char argv[])
{
    unsigned long seconds;

    if ( (argc <  2) && scanf( "%lu", &seconds )
    ||   (argc >= 2) && sscanf( argv[1], "%lu", & seconds ) )
    {
        printf( "%s\n", seconds2string(seconds) );
        return EXIT_SUCCESS;
    }

    return EXIT_FAILURE;
}
