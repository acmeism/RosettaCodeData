#include <stdio.h>

#define NUM_DOORS 100

int main(int argc, char *argv[])
{
  int is_open[NUM_DOORS] = { 0 } ;
  int * doorptr, * doorlimit = is_open + NUM_DOORS ;
  int pass ;

  /* do the N passes, go backwards because the order is not important */
  for ( pass= NUM_DOORS ; ( pass ) ; -- pass ) {
    for ( doorptr= is_open + ( pass-1 ); ( doorptr < doorlimit ) ; doorptr += pass ) {
      ( * doorptr ) ^= 1 ;
    }
  }

  /* output results */
  for ( doorptr= is_open ; ( doorptr != doorlimit ) ; ++ doorptr ) {
    printf("door #%ld is %s\n", ( doorptr - is_open ) + 1, ( * doorptr ) ? "open" : "closed" ) ;
  }
}
