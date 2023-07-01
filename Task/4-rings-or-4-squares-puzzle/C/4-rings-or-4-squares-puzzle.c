#include <stdio.h>

#define TRUE 1
#define FALSE 0

int a,b,c,d,e,f,g;
int lo,hi,unique,show;
int solutions;

void
bf()
{
    for (f = lo;f <= hi; f++)
        if ((!unique) ||
           ((f != a) && (f != c) && (f != d) && (f != g) && (f != e)))
            {
            b = e + f - c;
            if ((b >= lo) && (b <= hi) &&
                   ((!unique) || ((b != a) && (b != c) &&
                   (b != d) && (b != g) && (b != e) && (b != f))))
                {
                solutions++;
                if (show)
                    printf("%d %d %d %d %d %d %d\n",a,b,c,d,e,f,g);
                }
            }
}


void
ge()
{
    for (e = lo;e <= hi; e++)
        if ((!unique) || ((e != a) && (e != c) && (e != d)))
            {
            g = d + e;
            if ((g >= lo) && (g <= hi) &&
                   ((!unique) || ((g != a) && (g != c) &&
                   (g != d) && (g != e))))
                bf();
            }
}

void
acd()
{
    for (c = lo;c <= hi; c++)
        for (d = lo;d <= hi; d++)
            if ((!unique) || (c != d))
                {
                a = c + d;
                if ((a >= lo) && (a <= hi) &&
                   ((!unique) || ((c != 0) && (d != 0))))
                    ge();
                }
}


void
foursquares(int plo,int phi, int punique,int pshow)
{
    lo = plo;
    hi = phi;
    unique = punique;
    show = pshow;
    solutions = 0;

    printf("\n");

    acd();

    if (unique)
        printf("\n%d unique solutions in %d to %d\n",solutions,lo,hi);
    else
        printf("\n%d non-unique solutions in %d to %d\n",solutions,lo,hi);
}

main()
{
    foursquares(1,7,TRUE,TRUE);
    foursquares(3,9,TRUE,TRUE);
    foursquares(0,9,FALSE,FALSE);
}
