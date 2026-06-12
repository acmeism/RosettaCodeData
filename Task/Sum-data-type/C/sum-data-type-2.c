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

        printf("Integer   i = %d , address of i = %p\n",udat.i,&udat.i);

        udat.f = 3.14159;

        printf("Float     f = %f , address of f = %p\n",udat.f,&udat.f);

        udat.c = 'C';

        printf("Character c = %c , address of c = %p\n",udat.c,&udat.c);

        return 0;
}
