#include <stdbool.h>
#include <stdio.h>
#include <string.h>

int inv(int a) {
    return a ^ -1;
}

struct Zeckendorf {
    int dVal, dLen;
};

void a(struct Zeckendorf *self, int n) {
    void b(struct Zeckendorf *, int); // forward declare

    int i = n;
    while (true) {
        if (self->dLen < i) self->dLen = i;
        int j = (self->dVal >> (i * 2)) & 3;
        switch (j) {
        case 0:
        case 1:
            return;
        case 2:
            if (((self->dVal >> ((i + 1) * 2)) & 1) != 1) return;
            self->dVal += 1 << (i * 2 + 1);
            return;
        case 3:
            self->dVal = self->dVal & inv(3 << (i * 2));
            b(self, (i + 1) * 2);
            break;
        default:
            break;
        }
        i++;
    }
}

void b(struct Zeckendorf *self, int pos) {
    void increment(struct Zeckendorf *); // forward declare

    if (pos == 0) {
        increment(self);
        return;
    }
    if (((self->dVal >> pos) & 1) == 0) {
        self->dVal += 1 << pos;
        a(self, pos / 2);
        if (pos > 1) a(self, pos / 2 - 1);
    } else {
        self->dVal = self->dVal & inv(1 << pos);
        b(self, pos + 1);
        b(self, pos - (pos > 1 ? 2 : 1));
    }
}

void c(struct Zeckendorf *self, int pos) {
    if (((self->dVal >> pos) & 1) == 1) {
        self->dVal = self->dVal & inv(1 << pos);
        return;
    }
    c(self, pos + 1);
    if (pos > 0) {
        b(self, pos - 1);
    } else {
        increment(self);
    }
}

struct Zeckendorf makeZeckendorf(char *x) {
    struct Zeckendorf z = { 0, 0 };
    int i = strlen(x) - 1;
    int q = 1;

    z.dLen = i / 2;
    while (i >= 0) {
        z.dVal += (x[i] - '0') * q;
        q *= 2;
        i--;
    }

    return z;
}

void increment(struct Zeckendorf *self) {
    self->dVal++;
    a(self, 0);
}

void addAssign(struct Zeckendorf *self, struct Zeckendorf rhs) {
    int gn;
    for (gn = 0; gn < (rhs.dLen + 1) * 2; gn++) {
        if (((rhs.dVal >> gn) & 1) == 1) {
            b(self, gn);
        }
    }
}

void subAssign(struct Zeckendorf *self, struct Zeckendorf rhs) {
    int gn;
    for (gn = 0; gn < (rhs.dLen + 1) * 2; gn++) {
        if (((rhs.dVal >> gn) & 1) == 1) {
            c(self, gn);
        }
    }
    while ((((self->dVal >> self->dLen * 2) & 3) == 0) || (self->dLen == 0)) {
        self->dLen--;
    }
}

void mulAssign(struct Zeckendorf *self, struct Zeckendorf rhs) {
    struct Zeckendorf na = rhs;
    struct Zeckendorf nb = rhs;
    struct Zeckendorf nr = makeZeckendorf("0");
    struct Zeckendorf nt;
    int i;

    for (i = 0; i < (self->dLen + 1) * 2; i++) {
        if (((self->dVal >> i) & 1) > 0) addAssign(&nr, nb);
        nt = nb;
        addAssign(&nb, na);
        na = nt;
    }

    *self = nr;
}

void printZeckendorf(struct Zeckendorf z) {
    static const char *const dig[3] = { "00", "01", "10" };
    static const char *const dig1[3] = { "", "1", "10" };

    if (z.dVal == 0) {
        printf("0");
        return;
    } else {
        int idx = (z.dVal >> (z.dLen * 2)) & 3;
        int i;

        printf(dig1[idx]);
        for (i = z.dLen - 1; i >= 0; i--) {
            idx = (z.dVal >> (i * 2)) & 3;
            printf(dig[idx]);
        }
    }
}

int main() {
    struct Zeckendorf g;

    printf("Addition:\n");
    g = makeZeckendorf("10");
    addAssign(&g, makeZeckendorf("10"));
    printZeckendorf(g);
    printf("\n");
    addAssign(&g, makeZeckendorf("10"));
    printZeckendorf(g);
    printf("\n");
    addAssign(&g, makeZeckendorf("1001"));
    printZeckendorf(g);
    printf("\n");
    addAssign(&g, makeZeckendorf("1000"));
    printZeckendorf(g);
    printf("\n");
    addAssign(&g, makeZeckendorf("10101"));
    printZeckendorf(g);
    printf("\n\n");

    printf("Subtraction:\n");
    g = makeZeckendorf("1000");
    subAssign(&g, makeZeckendorf("101"));
    printZeckendorf(g);
    printf("\n");
    g = makeZeckendorf("10101010");
    subAssign(&g, makeZeckendorf("1010101"));
    printZeckendorf(g);
    printf("\n\n");

    printf("Multiplication:\n");
    g = makeZeckendorf("1001");
    mulAssign(&g, makeZeckendorf("101"));
    printZeckendorf(g);
    printf("\n");
    g = makeZeckendorf("101010");
    addAssign(&g, makeZeckendorf("101"));
    printZeckendorf(g);
    printf("\n");

    return 0;
}
