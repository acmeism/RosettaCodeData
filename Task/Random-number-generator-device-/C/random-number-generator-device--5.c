#include <stdio.h>
#include <stdlib.h>

/*
   (C) 2020 J.G.A. Debaere, all rights reserved 2020/10/29

    Put into Public Domain for individuals only

    Tested with NIST, Diehard, Diehard 3.31

    gcc -lm ./jpsrand_f.c -o ./jpsrand_f.o

    dieharder -a -f /tmp/tmp.bin

	I consider it TRNG,
	
	using Time, Hardddisk and Memory as the hardware component

	No warranty of any kind, "AS IS"
	
	Last time I tested  ( 2021/07/07 ) with dieharder:
	
	rgb_bitdist		|   8|    100000|     100|0.99716738|   WEAK 	
	rgb_lagged_sum	|   3|   1000000|     100|0.99661184|   WEAK
	
	Out of 114 tests, rest PASSED

        Obviously, it changes per run :)
	
*/

unsigned int  jps_rand()
{
    /* (C) 2020 J.G.A. Debaere, all rights reserved */

    #include   <dirent.h>

    #include <sys/time.h>

    struct timeval current_time ;

    DIR *folder ;

    struct dirent *en ;

    folder = opendir ( "." ) ;

    while ( ( folder ) && ( en = readdir ( folder ) ) != NULL )

        asm ( "nop" ) ;

    closedir ( folder ) ;

    gettimeofday( &current_time, NULL ) ;

    unsigned int t = ( current_time.tv_sec * current_time.tv_usec / 17.17 ) ;

    return t ;
}

int main()
{
    FILE * f1;

    f1 = fopen("/tmp/tmp.bin", "wb");


    unsigned int t = ( unsigned int ) jps_rand() ;

    for ( unsigned int k = 0;  k < 40000000 ; k++ )
    {
        t = jps_rand () ;

        fwrite ( &t, sizeof( unsigned int ),  1, f1 ) ;
    }

    fflush(f1);

    fclose(f1);

    return 0;
}
