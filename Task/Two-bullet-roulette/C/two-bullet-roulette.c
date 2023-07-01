#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static int nextInt(int size) {
    return rand() % size;
}

static bool cylinder[6];

static void rshift() {
    bool t = cylinder[5];
    int i;
    for (i = 4; i >= 0; i--) {
        cylinder[i + 1] = cylinder[i];
    }
    cylinder[0] = t;
}

static void unload() {
    int i;
    for (i = 0; i < 6; i++) {
        cylinder[i] = false;
    }
}

static void load() {
    while (cylinder[0]) {
        rshift();
    }
    cylinder[0] = true;
    rshift();
}

static void spin() {
    int lim = nextInt(6) + 1;
    int i;
    for (i = 1; i < lim; i++) {
        rshift();
    }
}

static bool fire() {
    bool shot = cylinder[0];
    rshift();
    return shot;
}

static int method(const char *s) {
    unload();
    for (; *s != '\0'; s++) {
        switch (*s) {
        case 'L':
            load();
            break;
        case 'S':
            spin();
            break;
        case 'F':
            if (fire()) {
                return 1;
            }
            break;
        }
    }
    return 0;
}

static void append(char *out, const char *txt) {
    if (*out != '\0') {
        strcat(out, ", ");
    }
    strcat(out, txt);
}

static void mstring(const char *s, char *out) {
    for (; *s != '\0'; s++) {
        switch (*s) {
        case 'L':
            append(out, "load");
            break;
        case 'S':
            append(out, "spin");
            break;
        case 'F':
            append(out, "fire");
            break;
        }
    }
}

static void test(char *src) {
    char buffer[41] = "";
    const int tests = 100000;
    int sum = 0;
    int t;
    double pc;

    for (t = 0; t < tests; t++) {
        sum += method(src);
    }

    mstring(src, buffer);
    pc = 100.0 * sum / tests;

    printf("%-40s produces %6.3f%% deaths.\n", buffer, pc);
}

int main() {
    srand(time(0));

    test("LSLSFSF");
    test("LSLSFF");
    test("LLSFSF");
    test("LLSFF");

    return 0;
}
