#include <iostream>
#include <map>
#include <cmath>

// Generate the Padovan sequence using the recurrence
// relationship.
int pRec(int n) {
    static std::map<int,int> memo;
    auto it = memo.find(n);
    if (it != memo.end()) return it->second;

    if (n <= 2) memo[n] = 1;
    else memo[n] = pRec(n-2) + pRec(n-3);
    return memo[n];
}

// Calculate the N'th Padovan sequence using the
// floor function.
int pFloor(int n) {
    long const double p = 1.324717957244746025960908854;
    long const double s = 1.0453567932525329623;
    return std::pow(p, n-1)/s + 0.5;
}

// Return the N'th L-system string
std::string& lSystem(int n) {
    static std::map<int,std::string> memo;
    auto it = memo.find(n);
    if (it != memo.end()) return it->second;

    if (n == 0) memo[n] = "A";
    else {
        memo[n] = "";
        for (char ch : memo[n-1]) {
            switch(ch) {
                case 'A': memo[n].push_back('B'); break;
                case 'B': memo[n].push_back('C'); break;
                case 'C': memo[n].append("AB"); break;
            }
        }
    }
    return memo[n];
}

// Compare two functions up to p_N
using pFn = int(*)(int);
void compare(pFn f1, pFn f2, const char* descr, int stop) {
    std::cout << "The " << descr << " functions ";
    int i;
    for (i=0; i<stop; i++) {
        int n1 = f1(i);
        int n2 = f2(i);
        if (n1 != n2) {
            std::cout << "do not match at " << i
                      << ": " << n1 << " != " << n2 << ".\n";
            break;
        }
    }
    if (i == stop) {
        std::cout << "match from P_0 to P_" << stop << ".\n";
    }
}

int main() {
    /* Print P_0 to P_19 */
    std::cout << "P_0 .. P_19: ";
    for (int i=0; i<20; i++) std::cout << pRec(i) << " ";
    std::cout << "\n";

    /* Check that floor and recurrence match up to P_64 */
    compare(pFloor, pRec, "floor- and recurrence-based", 64);

    /* Show first 10 L-system strings */
    std::cout << "\nThe first 10 L-system strings are:\n";
    for (int i=0; i<10; i++) std::cout << lSystem(i) << "\n";
    std::cout << "\n";

    /* Check lengths of strings against pFloor up to P_31 */
    compare(pFloor, [](int n){return (int)lSystem(n).length();},
                            "floor- and L-system-based", 32);
    return 0;
}
