#include <iostream>

// returns sum of squares of digits of n
unsigned int sum_square_digits(unsigned int n) {
        int i,num=n,sum=0;
        // process digits one at a time until there are none left
        while (num > 0) {
                // peal off the last digit from the number
                int digit=num % 10;
                num=(num - digit)/10;
                // add it's square to the sum
                sum+=digit*digit;
        }
        return sum;
}
int main(void) {
        unsigned int i=0,result=0, count=0;
        for (i=1; i<=100000000; i++) {
                // if not 1 or 89, start the iteration
                if ((i != 1) || (i != 89)) {
                        result = sum_square_digits(i);
                }
                // otherwise we're done already
                else {
                        result = i;
                }
                // while we haven't reached 1 or 89, keep iterating
                while ((result != 1) && (result != 89)) {
                        result = sum_square_digits(result);
                }
                if (result == 89) {
                        count++;
                }
        }
        std::cout << count << std::endl;
        return 0;
}
