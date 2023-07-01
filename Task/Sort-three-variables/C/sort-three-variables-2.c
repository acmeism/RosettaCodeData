#include<stdio.h>

int main()
{
  int x = 77444,y=-12,z=0,temp;

  printf("Before sorting :\nx = %d\ny = %d\nz = %d",x,y,z);

  do{
  temp = x;

  if(temp > y){
    x = y;
    y = temp;
  }

  if(z < y){
    temp = y;
    y = z;
    z = temp;
  }
  }while(x>y || y>z);

  printf("\nAfter sorting :\nx = %d\ny = %d\nz = %d",x,y,z);

  return 0;
}
