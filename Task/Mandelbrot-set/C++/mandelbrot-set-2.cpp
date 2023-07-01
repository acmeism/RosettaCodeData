#include <stdio.h>

int f(float X, float Y, float x, float y, int n){
return (x*x+y*y<4 && n<100)?1+f(X, Y, x*x-y*y+X, 2*x*y+Y, n+1):0;
}

main(){
for(float j=1; j>=-1; j-=.015)
for(float i=-2, x; i<=.5; i+=.015, x=f(i, j, 0, 0, 0))
printf("%c%s", x<10?' ':x<20?'.':x<50?':':x<80?'*':'#', i>-2?" ":"\n");
}
