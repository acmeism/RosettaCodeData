#include <math.h>

bool prime(int n) {
    if(n<=1) return false;
    if(n<4||n==5) return true;
    if(n%2==0||n%3==0) return false;
    int sq = sqrt(n);
    for (int i = 5; i <= sq; i+=6)
        if(n%i==0 || n%(i+2)==0) return false;
    return true;
}</syntaxhighlight >
