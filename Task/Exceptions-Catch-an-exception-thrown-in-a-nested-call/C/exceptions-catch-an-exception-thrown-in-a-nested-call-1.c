#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ucontext.h>

#define try push_handler(); if (!exc_string)
#define catch(e) pop_handler(e); for (; exc_string; exc_string = 0)

ucontext_t *exc;
int exc_depth = 0;
int exc_alloc = 0;
const char * exc_string;

void throw(const char *str)
{
        exc_string = str;
        setcontext(exc + exc_depth - 1);
}

void push_handler()
{
        exc_string = 0;
        if (exc_alloc <= exc_depth) {
                exc_alloc += 16;
                exc = realloc(exc, sizeof(ucontext_t) * exc_alloc);
        }
        getcontext(exc + exc_depth++);
}

void pop_handler(const char *e)
{
        exc_depth --;
        if (exc_string && strcmp(e, exc_string)) {
                if (exc_depth > 0)
                        throw(exc_string);
                fprintf(stderr, "Fatal: unhandled exception %s\n", exc_string);
                exit(1);
        }
}

/* try out the exception system */

void baz() {
        static int count = 0;
        switch (count++) {
                case 0: throw("U0");
                case 1: throw("U1");
                case 2: throw("U2");
        }
}

void foo()
{
        printf("    foo: calling baz\n");
        try { baz(); }
        catch("U0") {
                printf("    foo: got exception U0; handled and dandy\n");
        }

        printf("    foo: finished\n");
}

int main() {
        int i;
        for (i = 0; i < 3; i++) {
                printf("main: calling foo: %d\n", i);
                try { foo(); }
                catch("U1") {
                        printf("main: Someone threw U1; handled and dandy\n");
                }
        }
        return 0;
}
