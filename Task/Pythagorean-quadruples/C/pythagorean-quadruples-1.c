#include <stdio.h>
#include <math.h>
#include <string.h>

#define N 2200

int main(int argc, char **argv){
   int a,b,c,d;
   int r[N+1];
   memset(r,0,sizeof(r));	// zero solution array
   for(a=1; a<=N; a++){
      for(b=a; b<=N; b++){
	 int aabb;
	 if(a&1 && b&1) continue;  // for positive odd a and b, no solution.
	 aabb=a*a + b*b;
	 for(c=b; c<=N; c++){
	    int aabbcc=aabb + c*c;
	    d=(int)sqrt((float)aabbcc);
	    if(aabbcc == d*d && d<=N) r[d]=1;	// solution
	 }
      }
   }
   for(a=1; a<=N; a++)
      if(!r[a]) printf("%d ",a);	// print non solution
   printf("\n");
}
