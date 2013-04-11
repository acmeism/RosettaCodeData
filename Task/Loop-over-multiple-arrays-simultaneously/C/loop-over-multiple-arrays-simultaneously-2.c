#include <stdio.h>

typedef struct closure {
    void (*f)( void *elem, void *data);
    void  *data;
} *Closure;

typedef struct listSpec{
    void (*print)(const void *);
    void *ary;
    int  count;
    size_t elem_size;
} *ListSpec;

#define LIST_SPEC( pf,typ,aa) {pf, aa, (sizeof(aa)/sizeof(typ)), sizeof(typ) }


/* calls closure's function f for each element in list */
void DoForEach( Closure c, ListSpec aspec )
{
    int i;
    void *val_ptr;
    for (i=0, val_ptr=aspec->ary; i< aspec->count; i++) {
        (*c->f)(val_ptr, c->data);
         val_ptr = ((char *)val_ptr) + aspec->elem_size;
    }
}

/* Used to find the minimum array length of list of lists */
void FindMin( ListSpec *paspec, int *minCount )
{
    ListSpec aspec = *paspec;
    if (*minCount>aspec->count) *minCount = aspec->count;
}

/* prints an element of a list using the list's print function */
void PrintElement( ListSpec *paspec, int *indx )
{
    ListSpec aspec = *paspec;
    (*aspec->print)( ((char*)aspec->ary) + (*indx)*aspec->elem_size);
}


/* Loop Over multiple lists (a list of lists)*/
void LoopMultiple( ListSpec arrays)
{
    int indx;
    int minCount = 100000;
    struct closure c1 = { &FindMin, &minCount };
    struct closure xclsr = { &PrintElement, &indx };
    DoForEach( &c1, arrays);
    printf("min count = %d\n", minCount);

    for (indx=0; indx<minCount; indx++) {
        DoForEach(&xclsr, arrays );
        printf("\n");
    }
}

/* Defining our Lists */

void PrintInt(const int *ival)
{  printf("%3d,", *ival);
}
int ary1[] = { 6,5,4,9,8,7 };
struct listSpec lspec1 = LIST_SPEC( &PrintInt, int, ary1 );

void PrintShort(const short *ival)
{  printf("%3d,", *ival);
}
short ary2[] = { 3, 66, 20, 15, 7, 22, 10 };
struct listSpec lspec2 = LIST_SPEC( &PrintShort , short, ary2 );

void PrintStrg(const char *const *strg )
{  printf(" %s", *strg);
}
const char *ary3[] = {"Hello", "all", "you","good", "folks","out", "there" };
struct listSpec lspec3 = LIST_SPEC( &PrintStrg , const char *, ary3 );

void PrintLstSpec(const ListSpec *ls)
{  printf("not-implemented");
}
ListSpec listList[] = { &lspec1, &lspec2,  &lspec3 };
struct listSpec llSpec = LIST_SPEC(&PrintLstSpec, ListSpec, listList);

int main(int argc, char *argv[])
{
    LoopMultiple( &llSpec);
    return 0;
}
