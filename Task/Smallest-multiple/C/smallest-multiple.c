#include <stdio.h>
#define lcm(a,b) a/gcd(a,b)*b
#define ul unsigned long

ul gcd(ul a, ul b) {
    ul t;
    for (;b!=0;t=b,b=a%b,a=t);
    return a;
}

int main() {
    ul i=20, ret=1;
    const ul lim=i>>1;
    for(; i > lim; i--)
        ret = lcm(ret,i);
    printf("%lu", ret);
    return 0;
}
