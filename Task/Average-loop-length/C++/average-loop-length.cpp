#include <random>
#include <vector>
#include <iostream>

#define MAX_N 20
#define TIMES 1000000

/**
 * Used to generate a uniform random distribution
 */
static std::random_device rd;  //Will be used to obtain a seed for the random number engine
static std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
static std::uniform_int_distribution<> dis;

int randint(int n) {
    int r, rmax = RAND_MAX / n * n;
    dis=std::uniform_int_distribution(0,rmax) ;
    r = dis(gen);
    return r / (RAND_MAX / n);
}

unsigned long factorial(size_t n) {
    //Factorial using dynamic programming to memoize the values.
    static std::vector<unsigned long>factorials{1,1,2};
	for (;factorials.size() <= n;)
	    factorials.push_back(factorials.back()*factorials.size());
	return factorials[n];
}

long double expected(size_t n) {
    long double sum = 0;
    for (size_t i = 1; i <= n; i++)
        sum += factorial(n) / pow(n, i) / factorial(n - i);
    return sum;
}

int test(int n, int times) {
    int i, count = 0;
    for (i = 0; i < times; i++) {
        unsigned int x = 1, bits = 0;
        while (!(bits & x)) {
            count++;
            bits |= x;
            x = static_cast<unsigned int>(1 << randint(n));
        }
    }
    return count;
}

int main() {
    puts(" n\tavg\texp.\tdiff\n-------------------------------");

    int n;
    for (n = 1; n <= MAX_N; n++) {
        int cnt = test(n, TIMES);
        long double avg = (double)cnt / TIMES;
        long double theory = expected(static_cast<size_t>(n));
        long double diff = (avg / theory - 1) * 100;
        printf("%2d %8.4f %8.4f %6.3f%%\n", n, static_cast<double>(avg), static_cast<double>(theory), static_cast<double>(diff));
    }
    return 0;
}
