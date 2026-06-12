#include<stdio.h>

int main()
{
 int q,r;

 for(q=0;q<16;q++){
   for(r=10;r<16;r++){
     printf("%5d",16*q+r);
   }
 }

return 0;
}
