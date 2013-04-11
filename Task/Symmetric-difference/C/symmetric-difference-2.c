#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const char *mary="Mary";
const char *bob="Bob";
const char *jim="Jim";
const char *john="John";
const char *serena="Serena";

const char *setA[] = {john,bob,mary,serena};
const char *setB[] = {jim,mary,john,bob};

#define XSET(j)  j, (sizeof(j)/sizeof(*j))
#define TALLOC(n,typ) malloc(n*sizeof(typ))

typedef enum {
    esdDIFFERENCE,
    esdSYMMETRIC } EsdFunction;
/** * * * * * * * * * * * * * * * * * * * *
 * return value is difference or symmetric difference set
 *    its size is returned in sym_size
 *    f determinse whether it is a symmetric difference, or normal difference
 * * * * * * * * * * * * * * * * * * * * **/
const char ** symmdiff( int *sym_size, EsdFunction f, const char *setA[], int setAsize, const char *setB[], int setBsize)
{
    int union_size;
    int max_union_size;
    int diff_size;
    const char **union_set;
    const char **diff_set;
    int *union_xor;
    int ix, ixu;

    max_union_size = setAsize + setBsize;
    union_set = TALLOC(max_union_size, const char *);
    union_xor = TALLOC(max_union_size, int);

    /* I'm assuming here that setA has no duplicates,
     * i.e. is a set in mathematical sense */
    for (ix=0; ix<setAsize; ix++) {
        union_set[ix] = setA[ix];
        union_xor[ix] = 1;
    }
    diff_size = union_size = setAsize;
    for (ix=0; ix<setBsize; ix++) {
        for (ixu=0; ixu<union_size; ixu++) {
            if (union_set[ixu] == setB[ix]) break;
        }
        if (ixu < union_size) {	/* already in union */
            union_xor[ixu] = 1-union_xor[ixu];
            diff_size--;
        }
        else {		/* not already in union -add */
            if (f == esdSYMMETRIC) {
                union_set[ixu] = setB[ix];
                union_xor[ixu] = 1;
                union_size++;
                diff_size++;
            }
        }
    }
    /* Put results in symdiff set */
    diff_set = TALLOC(diff_size, const char *);
    ix = 0;
    for (ixu=0; ixu<union_size; ixu++) {
        if (union_xor[ixu]) {
            if (ix == diff_size) {
                printf("Short of space in diff_set\n");
                exit(1);
            }
            diff_set[ix] = union_set[ixu];
            ix++;
        }
    }
    *sym_size = diff_size;
    free(union_xor);
    free(union_set);
    return diff_set;
}

/* isSet tests that elements of list are unique, that is, that the list is a
 * mathematical set.  The uniqueness test implemented here is strcmp. */
int isSet(const char *list[], int lsize)
{
    int i, j;
    const char *e;
    if (lsize == 0) {
        return 1;
    }
    for (i = lsize-1; i>0; i--) {
        e = list[i];
        for (j = i-1; j>=0; j--) {
            if (strcmp(list[j], e) == 0) {
                return 0;
            }
        }
    }
    return 1;
}

void printSet (const char *set[], int ssize)
{
    int ix;
    printf(" = {");
    for (ix=0;ix<ssize; ix++) {
        printf( "%s ", set[ix]);
    }
    printf("}\n");
}

int main()
{
    const char **symset;
    int sysize;

    /* Validate precondition stated by task, that inputs are sets. */
    assert(isSet(XSET(setA)));
    assert(isSet(XSET(setB)));

    printf ("A symmdiff B");
    symset = symmdiff( &sysize, esdSYMMETRIC, XSET(setA), XSET(setB));
    printSet(symset, sysize);
    free(symset);
    printf ("A - B");
    symset = symmdiff( &sysize, esdDIFFERENCE, XSET(setA), XSET(setB));
    printSet(symset, sysize);
    printf ("B - A");
    symset = symmdiff( &sysize, esdDIFFERENCE, XSET(setB), XSET(setA));
    printSet(symset, sysize);
    free(symset);

    return 0;
}
