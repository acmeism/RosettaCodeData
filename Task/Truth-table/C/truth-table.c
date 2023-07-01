#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0
#define STACK_SIZE 80
#define BUFFER_SIZE 100

typedef int bool;

typedef struct {
    char name;
    bool val;
} var;

typedef struct {
    int top;
    bool els[STACK_SIZE];
} stack_of_bool;

char expr[BUFFER_SIZE];
int expr_len;
var vars[24];
int vars_len;

/* stack manipulation functions */

bool is_full(stack_of_bool *sp) {
    return sp->top == STACK_SIZE - 1;
}

bool is_empty(stack_of_bool *sp) {
    return sp->top == -1;
}

bool peek(stack_of_bool *sp) {
    if (!is_empty(sp))
        return sp->els[sp->top];
    else {
        printf("Stack is empty.\n");
        exit(1);
    }
}

void push(stack_of_bool *sp, bool val) {
    if (!is_full(sp)) {
        sp->els[++(sp->top)] = val;
    }
    else {
        printf("Stack is full.\n");
        exit(1);
    }
}

bool pop(stack_of_bool *sp) {
    if (!is_empty(sp))
        return sp->els[(sp->top)--];
    else {
        printf("\nStack is empty.\n");
        exit(1);
    }
}

void make_empty(stack_of_bool *sp) {
    sp->top = -1;
}

int elems_count(stack_of_bool *sp) {
    return (sp->top) + 1;
}

bool is_operator(const char c) {
   return c == '&' || c == '|' || c == '!' || c == '^';
}

int vars_index(const char c) {
   int i;
   for (i = 0; i < vars_len; ++i) {
       if (vars[i].name == c) return i;
   }
   return -1;
}

bool eval_expr() {
    int i, vi;
    char e;
    stack_of_bool s;
    stack_of_bool *sp = &s;
    make_empty(sp);
    for (i = 0; i < expr_len; ++i) {
        e = expr[i];
        if (e == 'T')
            push(sp, TRUE);
        else if (e == 'F')
            push(sp, FALSE);
        else if((vi = vars_index(e)) >= 0) {
            push(sp, vars[vi].val);
        }
        else switch(e) {
            case '&':
                push(sp, pop(sp) & pop(sp));
                break;
            case '|':
                push(sp, pop(sp) | pop(sp));
                break;
            case '!':
                push(sp, !pop(sp));
                break;
            case '^':
                push(sp, pop(sp) ^ pop(sp));
                break;
            default:
                printf("\nNon-conformant character '%c' in expression.\n", e);
                exit(1);
        }
    }
    if (elems_count(sp) != 1) {
        printf("\nStack should contain exactly one element.\n");
        exit(1);
    }
    return peek(sp);
}

void set_vars(int pos) {
    int i;
    if (pos > vars_len) {
        printf("\nArgument to set_vars can't be greater than the number of variables.\n");
        exit(1);
    }
    else if (pos == vars_len) {
        for (i = 0; i < vars_len; ++i) {
            printf((vars[i].val) ? "T  " : "F  ");
        }
        printf("%c\n", (eval_expr()) ? 'T' : 'F');
    }
    else {
        vars[pos].val = FALSE;
        set_vars(pos + 1);
        vars[pos].val = TRUE;
        set_vars(pos + 1);
    }
}

/* removes whitespace and converts to upper case */
void process_expr() {
    int i, count = 0;
    for (i = 0; expr[i]; ++i) {
        if (!isspace(expr[i])) expr[count++] = toupper(expr[i]);
    }
    expr[count] = '\0';
}

int main() {
    int i, h;
    char e;
    printf("Accepts single-character variables (except for 'T' and 'F',\n");
    printf("which specify explicit true or false values), postfix, with\n");
    printf("&|!^ for and, or, not, xor, respectively; optionally\n");
    printf("seperated by whitespace. Just enter nothing to quit.\n");

    while (TRUE) {
        printf("\nBoolean expression: ");
        fgets(expr, BUFFER_SIZE, stdin);
        fflush(stdin);
        process_expr();
        expr_len = strlen(expr);
        if (expr_len == 0) break;
        vars_len = 0;
        for (i = 0; i < expr_len; ++i) {
            e = expr[i];
            if (!is_operator(e) && e != 'T' && e != 'F' && vars_index(e) == -1) {
                vars[vars_len].name = e;
                vars[vars_len].val = FALSE;
                vars_len++;
            }
        }
        printf("\n");
        if (vars_len == 0) {
            printf("No variables were entered.\n");
        }
        else {
            for (i = 0; i < vars_len; ++i)
                printf("%c  ", vars[i].name);
            printf("%s\n", expr);
            h = vars_len * 3 + expr_len;
            for (i = 0; i < h; ++i) printf("=");
            printf("\n");
            set_vars(0);
        }
    }
    return 0;
}
