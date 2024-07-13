#include <stdio.h>
#include <string.h>

#define SIZE 21

void print_gen(int gen[], int size) {
    for (int i = 0; i < size; i++) {
        printf("%c", gen[i] ? '#' : '_');
    }
    printf("\n");
}

void evolve(int gen[], int size) {
    int next_gen[size + 2];
    next_gen[0] = next_gen[size + 1] = 0;

    for (int i = 0; i < size; i++) {
        next_gen[i + 1] = gen[i];
    }

    for (int i = 0; i < size; i++) {
        gen[i] = (next_gen[i] + next_gen[i + 1] + next_gen[i + 2]) == 2;
    }
}

int main() {
    char initial[] = "_###_##_#_#_#_#__#__";
    int gen[SIZE];

    for (int i = 0; i < SIZE; i++) {
        gen[i] = initial[i] == '#';
    }

    for (int n = 0; n < 10; n++) {
        print_gen(gen, SIZE);
        evolve(gen, SIZE);
    }

    return 0;
}
