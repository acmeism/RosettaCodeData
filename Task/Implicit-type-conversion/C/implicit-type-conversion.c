#include <stdio.h>
main(){
/* a representative sample of builtin types */
    unsigned char uc; char c;
    enum{e1, e2, e3}e123;
    short si; int i; long li;
    unsigned short su; unsigned u; unsigned long lu;
    float sf; float f; double lf; long double llf;
    union {char c; unsigned u; int i; float f; }ucuif;  /* manual casting only */
    struct {char c; unsigned u; int i; float f; }scuif; /* manual casting only */
    int ai[99];
    int (*rai)[99];
    int *ri;
    uc = '1';
/* a representitive sample of implied casts for subtypes of personality int/float */
    c=uc;
    si=uc; si=c;
    su=uc; su=c; su=si;
    i=uc;  i=c;  i=si;  i=su;
    e123=i; i=e123;
    u=uc;  u=c;  u=si;  u=su;  u=i;
    li=uc; li=c; li=si; li=su; li=i; li=u;
    lu=uc; lu=c; lu=si; lu=su; lu=i; lu=u; lu=li;
    sf=uc; sf=c; sf=si; sf=su; sf=i; sf=u; sf=li; sf=lu;
    f=uc;  f=c;  f=si;  f=su;  f=i;  f=u;  f=li;  f=lu;  f=sf;
    lf=uc; lf=c; lf=si; lf=su; lf=i; lf=u; lf=li; lf=lu; lf=sf; lf=f;
    llf=uc;llf=c;llf=si;llf=su;llf=i;llf=u;llf=li;llf=lu;llf=sf;llf=f;llf=lf;
/*  ucuif = i; no implied cast; try: iucuif.i = i */
/*  ai = i; no implied cast; try: rai = &i */
/* a representitive sample of implied casts, type pointer */
    rai = ai; /* starts at the first element of ai */
    ri = ai;  /* points to the first element of ai */
/* a summary result, using the longest sizeof increasing casting path */
    printf("%LF was increasingly cast from %d from %d from %d from %d from %d bytes from '%c'\n",
           llf=(lf=(i=(si=c))), sizeof llf, sizeof lf, sizeof i, sizeof si,sizeof c, c);
}
