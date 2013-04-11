#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#define INOUT_LEN 4
#define TIME_LEN 20
#define MAX_MAXOUT 1000

char inout[INOUT_LEN];
char time[TIME_LEN];
uint jobnum;

char maxtime[MAX_MAXOUT][TIME_LEN];

int main(int argc, char **argv)
{
  FILE *in = NULL;
  int l_out = 0, maxout=-1, maxcount=0;

  if ( argc > 1 ) {
    in = fopen(argv[1], "r");
    if ( in == NULL ) {
      fprintf(stderr, "cannot read %s\n", argv[1]);
      exit(1);
    }
  } else {
    in = stdin;
  }

  while( fscanf(in, "License %s @ %s for job %u\n", inout, time, &jobnum) != EOF ) {

    if ( strcmp(inout, "OUT") == 0 )
      l_out++;
    else
      l_out--;

    if ( l_out > maxout ) {
      maxout = l_out;
      maxcount=0; maxtime[0][0] = '\0';
    }
    if ( l_out == maxout ) {
      if ( maxcount < MAX_MAXOUT ) {
	strncpy(maxtime[maxcount], time, TIME_LEN);
	maxcount++;
      } else {
	fprintf(stderr, "increase MAX_MAXOUT (now it is %u)\n", MAX_MAXOUT);
	exit(1);
      }
    }
  }

  printf("Maximum simultaneous license use is %d at the following times:\n", maxout);
  for(l_out=0; l_out < maxcount; l_out++) {
    printf("%s\n", maxtime[l_out]);
  }

  if ( in != stdin ) fclose(in);
  exit(0);
}
