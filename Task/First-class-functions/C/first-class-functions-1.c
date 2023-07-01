#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/* declare a typedef for a function pointer */
typedef double (*Class2Func)(double);

/*A couple of functions with the above prototype */
double functionA( double v)
{
   return v*v*v;
}
double functionB(double v)
{
   return exp(log(v)/3);
}

/* A function taking a function as an argument */
double Function1( Class2Func f2, double val )
{
    return f2(val);
}

/*A function returning a function */
Class2Func WhichFunc( int idx)
{
   return (idx < 4) ? &functionA : &functionB;
}

/* A list of functions */
Class2Func funcListA[] = {&functionA, &sin, &cos, &tan };
Class2Func funcListB[] = {&functionB, &asin, &acos, &atan };

/* Composing Functions */
double InvokeComposed( Class2Func f1, Class2Func f2, double val )
{
   return f1(f2(val));
}

typedef struct sComposition {
   Class2Func f1;
   Class2Func f2;
} *Composition;

Composition Compose( Class2Func f1, Class2Func f2)
{
   Composition comp = malloc(sizeof(struct sComposition));
   comp->f1 = f1;
   comp->f2 = f2;
   return comp;
}

double CallComposed( Composition comp, double val )
{
    return comp->f1( comp->f2(val) );
}
/** * * * * * * * * * * * * * * * * * * * * * * * * * * */

int main(int argc, char *argv[])
{
   int ix;
   Composition c;

   printf("Function1(functionA, 3.0) = %f\n", Function1(WhichFunc(0), 3.0));

   for (ix=0; ix<4; ix++) {
       c = Compose(funcListA[ix], funcListB[ix]);
       printf("Compostion %d(0.9) = %f\n", ix, CallComposed(c, 0.9));
   }

   return 0;
}
