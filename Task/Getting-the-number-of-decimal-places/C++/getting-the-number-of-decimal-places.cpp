#include <iostream>
#include <cstring>

int findNumOfDec(const char *s) {
    int pos = 0;
    while (s[pos] && s[pos++] != '.') {}
    return strlen(s + pos);
}

void test(const char *s) {
    int num = findNumOfDec(s);
    const char *p  = num != 1 ? "s" : "";
    std::cout << s << " has " << num << " decimal" << p << "\n";
}

int main() {
    test("12");
    test("12.0");
    test("12.345");
    test("12.345555555555");
    test("12.3450");
    test("12.34555555555555555555");
    char str[64];
    sprintf(str, "%f", 1.2345e+54);
    test(str);
    return 0;
}
