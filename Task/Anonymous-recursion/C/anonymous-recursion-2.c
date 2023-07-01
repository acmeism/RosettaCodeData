#include <stdio.h>
int main(){
    int n = 3;
    printf("%d",({
        int fib(int n){
            if (n <= 1)
              return n;
            return fib(n-1) + fib(n-2);
        }
        fib(n);
    }));
    return 0;
}
