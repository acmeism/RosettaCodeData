#include <stdio.h>
#include <stdlib.h>

#include "writetimings.h"

double *tobesorted = NULL;
const char *bname = "data_";
const char *filetempl = "%s%s_%s.dat";
int datlengths[] = {100, 200, 300, 500, 1000, 5000, 10000, 50000, 100000};

testpiece_t testpieces[] =
{
//  MAKEPIECE(bubble),
  MAKEPIECE(shell),
  MAKEPIECE(merge),
  MAKEPIECE(insertion),
  MAKEPIECE(quick),
  MAKEPIECE(qsort),
  { NULL, NULL }
};

seqdef_t seqdefs[] =
{
  { "c1", fillwithconst },
  { "rr", fillwithrrange },
  { "sr", shuffledrange },
  { NULL, NULL }
};


MAKEACTION(bubble)
MAKEACTION(insertion)
MAKEACTION(quick)
MAKEACTION(shell)

int action_merge(int size)
{
  double *res = merge_sort(tobesorted, size);
  free(res); /* unluckly this affects performance */
  return 0;
}

int doublecompare( const void *a, const void *b )
{
  if ( *(const double *)a < *(const double *)b ) return -1;
  else return *(const double *)a > *(const double *)b;
}
int action_qsort(int size)
{
  qsort(tobesorted, size, sizeof(double), doublecompare);
  return 0;
}

int get_the_longest(int *a)
{
  int r = *a;
  while( *a > 0 ) {
    if ( *a > r ) r = *a;
    a++;
  }
  return r;
}


int main()
{
  int i, j, k, z, lenmax;
  char buf[BUFLEN];
  FILE *out;
  double thetime;

  lenmax = get_the_longest(datlengths);
  printf("Bigger data set has %d elements\n", lenmax);
  tobesorted = malloc(sizeof(double)*lenmax);
  if ( tobesorted == NULL ) return 1;

  setfillconst(1.0);

  for(i=0; testpieces[i].name != NULL; i++) {
    for(j=0; seqdefs[j].name != NULL; j++) {
      snprintf(buf, BUFLEN, filetempl, bname, testpieces[i].name,
	       seqdefs[j].name);
      out = fopen(buf, "w");
      if ( out == NULL ) goto severe;
      printf("Producing data for sort '%s', created data type '%s'\n",
	     testpieces[i].name, seqdefs[j].name);
      for(k=0; datlengths[k] > 0; k++) {
	printf("\tNumber of elements: %d\n", datlengths[k]);
	thetime = 0.0;
	seqdefs[j].seqcreator(tobesorted, datlengths[k]);
	fprintf(out, "%d ", datlengths[k]);
	for(z=0; z < MEANREPEAT; z++) {
	  thetime += time_it(testpieces[i].action, datlengths[k]);
	}
	thetime /= MEANREPEAT;
	fprintf(out, "%.8lf\n", thetime);
      }
      fclose(out);
    }
  }
severe:
  free(tobesorted);
  return 0;
}
