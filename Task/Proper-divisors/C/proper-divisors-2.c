#include <stdio.h>
#include <stdbool.h>

int proper_divisors(const int n, bool print_flag)
{
    int count = 0;

    for (int i = 1; i < n; ++i) {
        if (n % i == 0) {
            count++;
            if (print_flag)
                printf("%d ", i);
        }
    }

    if (print_flag)
        printf("\n");

    return count;
}

int countProperDivisors(int n){
	int prod = 1,i,count=0;
	
	while(n%2==0){
		count++;
		n /= 2;
	}
	
	prod *= (1+count);

	for(i=3;i*i<=n;i+=2){
		count = 0;
		
		while(n%i==0){
			count++;
			n /= i;
		}
		
		prod *= (1+count);
	}
	
	if(n>2)
		prod *= 2;
	
	return prod - 1;
}

int main(void)
{
    for (int i = 1; i <= 10; ++i) {
        printf("%d: ", i);
        proper_divisors(i, true);
    }

    int max = 0;
    int max_i = 1;

    for (int i = 1; i <= 20000; ++i) {
        int v = countProperDivisors(i);
        if (v >= max) {
            max = v;
            max_i = i;
        }
    }

    printf("%d with %d divisors\n", max_i, max);
    return 0;
}
