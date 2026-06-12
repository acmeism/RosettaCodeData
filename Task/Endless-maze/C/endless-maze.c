#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int xp=127, yp=127, a=0, na=0, n, f, d, *x, *y, *e;
char entry[255];

int main(void) {

 srand(time(NULL));
 f = rand()%4;

 while (1) {

  a=na;
  for (n=0;n<na;n++) {
   if (x[n]==xp && y[n]==yp) {a=n; break;}
   }

  if (a == na) {
   na++;
   x = (int*) (a<1)?malloc(sizeof(int)):realloc(x,na*sizeof(int));
   y = (int*) (a<1)?malloc(sizeof(int)):realloc(y,na*sizeof(int));
   e = (int*) (a<1)?malloc(4*sizeof(int)):realloc(e,4*na*sizeof(int));
   x[a]=xp; y[a]=yp;
   for (n=0;n<4;n++) {e[4*a+n] = rand()%2;}
   for(n=0;n<na;n++) {
         if (x[n]==x[a]+1 && y[n]==y[a]  ) {e[4*a  ]=e[4*n+2];}
    else if (x[n]==x[a]   && y[n]==y[a]+1) {e[4*a+1]=e[4*n+3];}
    else if (x[n]==x[a]-1 && y[n]==y[a]  ) {e[4*a+2]=e[4*n  ];}
    else if (x[n]==x[a]   && y[n]==y[a]-1) {e[4*a+3]=e[4*n+1];}
    }
   }

  printf("Paths:");

  if ( e[4*a+(f  )%4] )  { printf(" ahead"); }
  if ( e[4*a+(f+1)%4] )  { printf(" right"); }
  if ( e[4*a+(f+2)%4] )  { printf(" back"); }
  if ( e[4*a+(f+3)%4] )  { printf(" left"); }
  printf("\n");

  d=-1;
  entry[0]=0;
  while (d<0) {

   printf(">");
   scanf("%s",&entry);
   if (!strcmp(entry,"ahead")) { d=f%4;     }
   else if (!strcmp(entry,"right")) { d=(f+1)%4; }
   else if (!strcmp(entry,"back")) { d=(f+2)%4; }
   else if (!strcmp(entry,"left")) { d=(f+3)%4; }
   else if (!strcmp(entry,"quit")) { getchar(); return(0); }
   else {printf("Invalid.\n"); continue;}

   switch (d) {
    case 0: if (e[4*a  ]) {xp++; f=d;} else {d=-1;}; break;
    case 1: if (e[4*a+1]) {yp++; f=d;} else {d=-1;}; break;
    case 2: if (e[4*a+2]) {xp--; f=d;} else {d=-1;}; break;
    case 3: if (e[4*a+3]) {yp--; f=d;} else {d=-1;}; break;
    }

   if (d<0) {printf("No path.");}
   }

  }

 }
