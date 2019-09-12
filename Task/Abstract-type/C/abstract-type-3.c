#include "silly.h"
#include <string.h>
#include <stdio.h>

struct sillyStruct {
    double  v1;
    char   str[32];
};

Silly NewSilly(double vInit, const char *strInit)
{
    Silly sily = malloc(sizeof( struct sillyStruct ));
    sily->v1 = vInit;
    sily->str[0] = '\0';
    strncat(sily->str, strInit, 31);
    return sily;
}

static
int MyMethod1(  AbsCls c, int a)
{
    Silly s = (Silly)(c->instData);
    return a+strlen(s->str);
}

static
const char *MyMethod2(AbsCls c, int b)
{
    Silly s = (Silly)(c->instData);
    sprintf(s->str, "%d", b);
    return s->str;
}

static
void  MyMethod3(AbsCls c, double d)
{
    Silly s = (Silly)(c->instData);
    printf("InMyMethod3, %f\n",s->v1 * d);
}

ABSTRACT_METHODS( Silly, MyMethod1, MyMethod2, MyMethod3)
