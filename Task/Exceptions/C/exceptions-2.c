#include <stdio.h>
#include <setjmp.h>
#include <stdlib.h>

enum exceptions {
        EXCEPTION_1 = 1,
        EXCEPTION_2,
        EXCEPTION_3
};


#define throw(exception) do {                                   \
                if (exp)                                        \
                        longjmp(*exp, exception);               \
                printf("uncaught exception %d\n", exception);   \
                exit(exception);                                \
        } while (0)

#define try(block, catch_block)                 \
{                                               \
        jmp_buf *exception_outer = exp;         \
        jmp_buf exception_inner;                \
        exp = &exception_inner;                 \
        int exception = setjmp(*exp);           \
        if (!exception) {                       \
                do block while(0);              \
                exp = exception_outer;          \
        } else {                                \
                exp = exception_outer;          \
                switch(exception) {             \
                catch_block                     \
                default:                        \
                        throw(exception);       \
                }                               \
        }                                       \
}

#define catch(exception, block) \
        case exception: do block while (0); break;


#define throws  jmp_buf* exp

// define a throwing function
void g(throws) {
        printf("g !\n");
        throw(EXCEPTION_1);
        printf("shouldnt b here\n");
}

void h(throws, int a)
{
        printf("h %d!\n", a);
        throw(EXCEPTION_2);
}

void f(throws) {
        try({
                g(exp); // call g with intention to catch exceptions
        },
        catch(EXCEPTION_1, {
                printf("exception 1\n");
                h(exp, 50); // will throw exception 2 inside this catch block
        }))
}

int main(int argc, char* argv[])
{
        throws = NULL; // define exception stack base
        try({
                f(exp);
        },
        catch(EXCEPTION_2, {
                printf("exception 2\n");
        })
        catch(EXCEPTION_3, {
                printf("exception 3\n");
        }))

        h(exp, 60); // will result in "uncaught exception"
        return 0;
}
