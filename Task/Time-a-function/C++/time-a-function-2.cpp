// Compile with:
// g++ -std=c++20 -Wall -Wextra -pedantic -O0 func-time.cpp -o func-time

#include <iostream>
#include <chrono>

template<typename f>
double measure(f func) {
    auto start = std::chrono::steady_clock::now(); // Starting point
    (*func)(); // Run the function
    auto end = std::chrono::steady_clock::now(); // End point

    return std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count(); // By default, return time by milliseconds
}

/*
Test functions:
    identity(): returns a number
    addmillion(): add 1,000,000 to a number, one by one, using a for-loop
*/

int identity(int x) { return x; }

int addmillion(int num) {
    for (int i = 0; i < 1000000; i++)
        num += i;
    return num;
}

int main() {
    double time;
    time = measure([](){ return identity(10); });
    // Shove the function into a lambda function.
    // Yeah, I couldn't think of any better workaround.
    std::cout << "identity(10)\t\t" << time << " milliseconds / " << time / 1000 << " seconds" << std::endl; // Print it
    time = measure([](){ return addmillion(1800); });
    std::cout << "addmillion(1800)\t" << time << " milliseconds / " << time / 1000 << " seconds" << std::endl;

    return 0;
}
