#include<stdio.h>
long long seed;
long long random(){
        seed = seed * seed / 1000 % 1000000;
        return seed;
}
int main(){
        seed = 675248;
        for(int i=1;i<=5;i++)
                printf("%lld\n",random());
        return 0;
}
