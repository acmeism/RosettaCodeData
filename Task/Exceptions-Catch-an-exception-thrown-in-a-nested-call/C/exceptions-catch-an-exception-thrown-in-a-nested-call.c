#include <stdio.h>
#include <stdlib.h>

typedef struct exception {
        int extype;
        char what[128];
} exception;

typedef struct exception_ctx {
        exception * exs;
        int size;
        int pos;
} exception_ctx;

exception_ctx * Create_Ex_Ctx(int length) {
        const int safety = 8; // alignment precaution.
        char * tmp = (char*) malloc(safety+sizeof(exception_ctx)+sizeof(exception)*length);
        if (! tmp) return NULL;
        exception_ctx * ctx = (exception_ctx*)tmp;
        ctx->size = length;
        ctx->pos = -1;
        ctx->exs = (exception*) (tmp + sizeof(exception_ctx));
        return ctx;
}

void Free_Ex_Ctx(exception_ctx * ctx) {
        free(ctx);
}

int Has_Ex(exception_ctx * ctx) {
        return (ctx->pos >= 0) ? 1 : 0;
}

int Is_Ex_Type(exception_ctx * exctx, int extype) {
        return (exctx->pos >= 0 && exctx->exs[exctx->pos].extype == extype) ? 1 : 0;
}

void Pop_Ex(exception_ctx * ctx) {
        if (ctx->pos >= 0) --ctx->pos;
}

const char * Get_What(exception_ctx * ctx) {
        if (ctx->pos >= 0) return ctx->exs[ctx->pos].what;
        return NULL;
}

int Push_Ex(exception_ctx * exctx, int extype, const char * msg) {
        if (++exctx->pos == exctx->size) {
                // Use last slot and report error.
                --exctx->pos;
                fprintf(stderr, "*** Error: Overflow in exception context.\n");
        }
        snprintf(exctx->exs[exctx->pos].what, sizeof(exctx->exs[0].what), "%s", msg);
        exctx->exs[exctx->pos].extype = extype;
        return -1;
}

//////////////////////////////////////////////////////////////////////

exception_ctx * GLOBALEX = NULL;
enum { U0_DRINK_ERROR = 10, U1_ANGRYBARTENDER_ERROR };

void baz(int n) {
        if (! n) {
                Push_Ex(GLOBALEX, U0_DRINK_ERROR , "U0 Drink Error. Insufficient drinks in bar Baz.");
                return;
        }
        else {
                Push_Ex(GLOBALEX, U1_ANGRYBARTENDER_ERROR , "U1 Bartender Error. Bartender kicked customer out of bar Baz.");
                return;
        }
}

void bar(int n) {
        fprintf(stdout, "Bar door is open.\n");
        baz(n);
        if (Has_Ex(GLOBALEX)) goto bar_cleanup;
        fprintf(stdout, "Baz has been called without errors.\n");
bar_cleanup:
        fprintf(stdout, "Bar door is closed.\n");
}

void foo() {
        fprintf(stdout, "Foo entering bar.\n");
        bar(0);
        while (Is_Ex_Type(GLOBALEX, U0_DRINK_ERROR)) {
                fprintf(stderr, "I am foo() and I deaall wrth U0 DriNk Errors with my own bottle... GOT oNE! [%s]\n", Get_What(GLOBALEX));
                Pop_Ex(GLOBALEX);
        }
        if (Has_Ex(GLOBALEX)) return;
        fprintf(stdout, "Foo left the bar.\n");
        fprintf(stdout, "Foo entering bar again.\n");
        bar(1);
        while (Is_Ex_Type(GLOBALEX, U0_DRINK_ERROR)) {
                fprintf(stderr, "I am foo() and I deaall wrth U0 DriNk Errors with my own bottle... GOT oNE! [%s]\n", Get_What(GLOBALEX));
                Pop_Ex(GLOBALEX);
        }
        if (Has_Ex(GLOBALEX)) return;
        fprintf(stdout, "Foo left the bar.\n");
}


int main(int argc, char ** argv) {
        exception_ctx * ctx = Create_Ex_Ctx(5);
        GLOBALEX = ctx;

        foo();
        if (Has_Ex(ctx)) goto main_ex;

        fprintf(stdout, "No errors encountered.\n");

main_ex:
        while (Has_Ex(ctx)) {
                fprintf(stderr, "*** Error: %s\n", Get_What(ctx));
                Pop_Ex(ctx);
        }
        Free_Ex_Ctx(ctx);
        return 0;
}
