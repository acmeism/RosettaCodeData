#ifndef _WRITETIMINGS_H
#define _WRITETIMINGS_H
#include "sorts.h"
#include "csequence.h"
#include "timeit.h"

/* we repeat the same MEANREPEAT times, and get the mean; this *should*
   give "better" results ... */
#define MEANREPEAT 10.0
#define BUFLEN 128
#define MAKEACTION(ALGO) \
  int action_ ## ALGO (int size) {				\
    ALGO ## _sort(tobesorted, size);				\
    return 0; }
#define MAKEPIECE(N) { #N , action_ ## N }

int action_bubble(int size);
int action_shell(int size);
int action_quick(int size);
int action_insertion(int size);
int action_merge(int size);
int doublecompare( const void *a, const void *b );
int action_qsort(int size);
int get_the_longest(int *a);

struct testpiece
{
  const char *name;
  int (*action)(int);
};
typedef struct testpiece testpiece_t;

struct seqdef
{
  const char *name;
  void (*seqcreator)(double *, int);
};
typedef struct seqdef seqdef_t;
#endif
