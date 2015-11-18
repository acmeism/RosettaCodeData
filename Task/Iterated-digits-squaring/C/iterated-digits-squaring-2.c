#include <stdio.h>

const int digits[] = { 0,1,2,3,4,5,6,7,8,9 };

// calculates factorial of a number
int factorial(int n) {
    return n == 0 ? 1 : n * factorial(n - 1);
}

// returns sum of squares of digits of n
unsigned int sum_square_digits(unsigned int n) {
        int i,num=n,sum=0;
        // process digits one at a time until there are none left
        while (num > 0) {
                // peal off the last digit from the number
                int digit=num % 10;
                num=(num - digit)/10;
                // add it's square to the sum
                sum=sum+digit*digit;
        }
        return sum;
}

// builds all combinations digits 0-9 of length len
// for each of these it will perform iterated digit squaring
// and for those which result in 89 add to a counter which is
// passed by pointer.
long choose_sum_and_count_89(int * got, int n_chosen, int len, int at, int max_types, int *count89)
{
        int i;
        long count = 0;
        int digitcounts[10];
        for (i=0; i < 10; i++) {
                digitcounts[i]=0;
        }
        if (n_chosen == len) {
                if (!got) return 1;

                int sum=0;
                for (i = 0; i < len; i++) {
                        int digit=digits[got[i]];
                        digitcounts[digit]++;
                        sum=sum + digit * digit;
                }
                if (sum == 0) {
                        return 1;
                }
                if ((sum != 1) && (sum != 89)) {
                        while ((sum != 1) && (sum != 89)) {
                                sum=sum_square_digits(sum);
                        }
                }
                if (sum == 89) {
                        int count_this_comb=factorial(len);
                        for (i=0; i<10; i++) {
                                count_this_comb/=factorial(digitcounts[i]);
                        }
                        (*count89)+=count_this_comb;
                }

                return 1;
        }

        for (i = at; i < max_types; i++) {
                if (got) got[n_chosen] = i;
                count += choose_sum_and_count_89(got, n_chosen + 1, len, i, max_types, count89);
        }
        return count;
}

int main(void)
{
        int chosen[10];
        int count=0;
        // build all unique 8 digit combinations which represent
        // numbers 0-99,999,999 and count those
        // whose iterated digit squaring sum to 89
        // case 0, 100,000,000 are ignored since they don't sum to 89
        choose_sum_and_count_89(chosen, 0, 8, 0, 10, &count);
        printf("%d\n",count);
        return 0;
}
