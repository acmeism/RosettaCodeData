#include<stdio.h>

typedef union data{
        int i;
        float f;
        char c;
}united;

int main()
{
        united udat;

        udat.i = 5;
        udat.f = 3.14159;
        udat.c = 'C';

        printf("Integer   i = %d , address of i = %p\n",udat.i,&udat.i);
        printf("Float     f = %f , address of f = %p\n",udat.f,&udat.f);
        printf("Character c = %c , address of c = %p\n",udat.c,&udat.c);

        return 0;
}
