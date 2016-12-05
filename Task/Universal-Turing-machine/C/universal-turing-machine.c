#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

enum {
    LEFT,
    RIGHT,
    STAY
};

typedef struct {
    int state1;
    int symbol1;
    int symbol2;
    int dir;
    int state2;
} transition_t;

typedef struct tape_t tape_t;
struct tape_t {
    int symbol;
    tape_t *left;
    tape_t *right;
};

typedef struct {
    int states_len;
    char **states;
    int final_states_len;
    int *final_states;
    int symbols_len;
    char *symbols;
    int blank;
    int state;
    int tape_len;
    tape_t *tape;
    int transitions_len;
    transition_t ***transitions;
} turing_t;

int state_index (turing_t *t, char *state) {
    int i;
    for (i = 0; i < t->states_len; i++) {
        if (!strcmp(t->states[i], state)) {
            return i;
        }
    }
    return 0;
}

int symbol_index (turing_t *t, char symbol) {
    int i;
    for (i = 0; i < t->symbols_len; i++) {
        if (t->symbols[i] == symbol) {
            return i;
        }
    }
    return 0;
}

void move (turing_t *t, int dir) {
    tape_t *orig = t->tape;
    if (dir == RIGHT) {
        if (orig && orig->right) {
            t->tape = orig->right;
        }
        else {
            t->tape = calloc(1, sizeof (tape_t));
            t->tape->symbol = t->blank;
            if (orig) {
                t->tape->left = orig;
                orig->right = t->tape;
            }
        }
    }
    else if (dir == LEFT) {
        if (orig && orig->left) {
            t->tape = orig->left;
        }
        else {
            t->tape = calloc(1, sizeof (tape_t));
            t->tape->symbol = t->blank;
            if (orig) {
                t->tape->right = orig;
                orig->left = t->tape;
            }
        }
    }
}

turing_t *create (int states_len, ...) {
    va_list args;
    va_start(args, states_len);
    turing_t *t = malloc(sizeof (turing_t));
    t->states_len = states_len;
    t->states = malloc(states_len * sizeof (char *));
    int i;
    for (i = 0; i < states_len; i++) {
        t->states[i] = va_arg(args, char *);
    }
    t->final_states_len = va_arg(args, int);
    t->final_states = malloc(t->final_states_len * sizeof (int));
    for (i = 0; i < t->final_states_len; i++) {
        t->final_states[i] = state_index(t, va_arg(args, char *));
    }
    t->symbols_len = va_arg(args, int);
    t->symbols = malloc(t->symbols_len);
    for (i = 0; i < t->symbols_len; i++) {
        t->symbols[i] = va_arg(args, int);
    }
    t->blank = symbol_index(t, va_arg(args, int));
    t->state = state_index(t, va_arg(args, char *));
    t->tape_len = va_arg(args, int);
    t->tape = NULL;
    for (i = 0; i < t->tape_len; i++) {
        move(t, RIGHT);
        t->tape->symbol = symbol_index(t, va_arg(args, int));
    }
    if (!t->tape_len) {
        move(t, RIGHT);
    }
    while (t->tape->left) {
        t->tape = t->tape->left;
    }
    t->transitions_len = va_arg(args, int);
    t->transitions = malloc(t->states_len * sizeof (transition_t **));
    for (i = 0; i < t->states_len; i++) {
        t->transitions[i] = malloc(t->symbols_len * sizeof (transition_t *));
    }
    for (i = 0; i < t->transitions_len; i++) {
        transition_t *tran = malloc(sizeof (transition_t));
        tran->state1 = state_index(t, va_arg(args, char *));
        tran->symbol1 = symbol_index(t, va_arg(args, int));
        tran->symbol2 = symbol_index(t, va_arg(args, int));
        tran->dir = va_arg(args, int);
        tran->state2 = state_index(t, va_arg(args, char *));
        t->transitions[tran->state1][tran->symbol1] = tran;
    }
    va_end(args);
    return t;
}

void print_state (turing_t *t) {
    printf("%-10s ", t->states[t->state]);
    tape_t *tape = t->tape;
    while (tape->left) {
        tape = tape->left;
    }
    while (tape) {
        if (tape == t->tape) {
            printf("[%c]", t->symbols[tape->symbol]);
        }
        else {
            printf(" %c ", t->symbols[tape->symbol]);
        }
        tape = tape->right;
    }
    printf("\n");
}

void run (turing_t *t) {
    int i;
    while (1) {
        print_state(t);
        for (i = 0; i < t->final_states_len; i++) {
            if (t->final_states[i] == t->state) {
                return;
            }
        }
        transition_t *tran = t->transitions[t->state][t->tape->symbol];
        t->tape->symbol = tran->symbol2;
        move(t, tran->dir);
        t->state = tran->state2;
    }
}

int main () {
    printf("Simple incrementer\n");
    turing_t *t = create(
        /* states */        2, "q0", "qf",
        /* final_states */  1, "qf",
        /* symbols */       2, 'B', '1',
        /* blank */         'B',
        /* initial_state */ "q0",
        /* initial_tape */  3, '1', '1', '1',
        /* transitions */   2,
                            "q0", '1', '1', RIGHT, "q0",
                            "q0", 'B', '1', STAY, "qf"
    );
    run(t);
    printf("\nThree-state busy beaver\n");
    t = create(
        /* states */        4, "a", "b", "c", "halt",
        /* final_states */  1, "halt",
        /* symbols */       2, '0', '1',
        /* blank */         '0',
        /* initial_state */ "a",
        /* initial_tape */  0,
        /* transitions */   6,
                            "a", '0', '1', RIGHT, "b",
                            "a", '1', '1', LEFT, "c",
                            "b", '0', '1', LEFT, "a",
                            "b", '1', '1', RIGHT, "b",
                            "c", '0', '1', LEFT, "b",
                            "c", '1', '1', STAY, "halt"
    );
    run(t);
    return 0;
    printf("\nFive-state two-symbol probable busy beaver\n");
    t = create(
        /* states */        6, "A", "B", "C", "D", "E", "H",
        /* final_states */  1, "H",
        /* symbols */       2, '0', '1',
        /* blank */         '0',
        /* initial_state */ "A",
        /* initial_tape */  0,
        /* transitions */   10,
                            "A", '0', '1', RIGHT, "B",
                            "A", '1', '1', LEFT, "C",
                            "B", '0', '1', RIGHT, "C",
                            "B", '1', '1', RIGHT, "B",
                            "C", '0', '1', RIGHT, "D",
                            "C", '1', '0', LEFT, "E",
                            "D", '0', '1', LEFT, "A",
                            "D", '1', '1', LEFT, "D",
                            "E", '0', '1', STAY, "H",
                            "E", '1', '0', LEFT, "A"
    );
    run(t);
}
