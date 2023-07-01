#include <stdio.h>

struct ModularArithmetic {
    int value;
    int modulus;
};

struct ModularArithmetic make(const int value, const int modulus) {
    struct ModularArithmetic r = { value % modulus, modulus };
    return r;
}

struct ModularArithmetic add(const struct ModularArithmetic a, const struct ModularArithmetic b) {
    return make(a.value + b.value, a.modulus);
}

struct ModularArithmetic addi(const struct ModularArithmetic a, const int v) {
    return make(a.value + v, a.modulus);
}

struct ModularArithmetic mul(const struct ModularArithmetic a, const struct ModularArithmetic b) {
    return make(a.value * b.value, a.modulus);
}

struct ModularArithmetic pow(const struct ModularArithmetic b, int pow) {
    struct ModularArithmetic r = make(1, b.modulus);
    while (pow-- > 0) {
        r = mul(r, b);
    }
    return r;
}

void print(const struct ModularArithmetic v) {
    printf("ModularArithmetic(%d, %d)", v.value, v.modulus);
}

struct ModularArithmetic f(const struct ModularArithmetic x) {
    return addi(add(pow(x, 100), x), 1);
}

int main() {
    struct ModularArithmetic input = make(10, 13);
    struct ModularArithmetic output = f(input);

    printf("f(");
    print(input);
    printf(") = ");
    print(output);
    printf("\n");

    return 0;
}
