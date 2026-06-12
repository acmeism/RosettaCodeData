#include <iostream>

template <typename T>
auto typeString(const T&) {
    return typeid(T).name();
}

class C {};
struct S {};

int main() {
    std::cout << typeString(1) << '\n';
    std::cout << typeString(1L) << '\n';
    std::cout << typeString(1.0f) << '\n';
    std::cout << typeString(1.0) << '\n';
    std::cout << typeString('c') << '\n';
    std::cout << typeString("string") << '\n';
    std::cout << typeString(C{}) << '\n';
    std::cout << typeString(S{}) << '\n';
    std::cout << typeString(nullptr) << '\n';
}
