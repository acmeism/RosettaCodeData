#include <iostream>

int digitSum(int n) {
    int s = 0;
    do {s += n % 10;} while (n /= 10);
    return s;
}

int main() {
    for (int i=0; i<1000; i++) {
        auto s_i = std::to_string(i);
        auto s_ds = std::to_string(digitSum(i));
        if (s_i.find(s_ds) != std::string::npos) {
            std::cout << i << " ";
        }
    }
    std::cout << std::endl;
    return 0;
}
