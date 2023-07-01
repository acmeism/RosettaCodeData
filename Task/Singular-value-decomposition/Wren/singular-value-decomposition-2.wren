/* gcc svd_embedded.c -o svd_embedded -lgsl -lgslcblas -lwren -lm */

#include <stdio.h>
#include <string.h>
#include <gsl/gsl_linalg.h>
#include "wren.h"

void C_svd(WrenVM* vm) {
    int r = (int)wrenGetSlotDouble(vm, 1);
    int c = (int)wrenGetSlotDouble(vm, 2);
    int l = r * c;
    double a[l];
    for (int i = 0; i < l; ++i) {
        wrenGetListElement(vm, 3, i, 1);
        a[i] = wrenGetSlotDouble(vm, 1);
    }
    gsl_matrix_view A = gsl_matrix_view_array(a, r, c);
    gsl_matrix *V = gsl_matrix_alloc(r, c);
    gsl_vector *S = gsl_vector_alloc(r);
    gsl_vector *work = gsl_vector_alloc(r);

    /* V is returned here in untransposed form. */
    gsl_linalg_SV_decomp(&A.matrix, V, S, work);
    gsl_matrix_transpose(V);
    double s[] = {S->data[0], 0, 0, S->data[1]};
    gsl_matrix_view SM = gsl_matrix_view_array(s, 2, 2);

    for (int i = 0; i < r; ++i) {
       for (int j = 0; j < c; ++j) {
            int ix = i*c + j;
            wrenSetSlotDouble(vm, 1, gsl_matrix_get(&A.matrix, i, j));
            wrenSetListElement(vm, 3, ix, 1);
            wrenSetSlotDouble(vm, 1, gsl_matrix_get(V, i, j));
            wrenSetListElement(vm, 4, ix, 1);
            wrenSetSlotDouble(vm, 1, gsl_matrix_get(&SM.matrix, i, j));
            wrenSetListElement(vm, 5, ix, 1);
        }
    }

    gsl_matrix_free(V);
    gsl_vector_free(S);
    gsl_vector_free(work);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "GSL") == 0) {
            if (isStatic && strcmp(signature, "svd(_,_,_,_,_)") == 0)  return C_svd;
        }
    }
    return NULL;
}

static void writeFn(WrenVM* vm, const char* text) {
    printf("%s", text);
}

void errorFn(WrenVM* vm, WrenErrorType errorType, const char* module, const int line, const char* msg) {
    switch (errorType) {
        case WREN_ERROR_COMPILE:
            printf("[%s line %d] [Error] %s\n", module, line, msg);
            break;
        case WREN_ERROR_STACK_TRACE:
            printf("[%s line %d] in %s\n", module, line, msg);
            break;
        case WREN_ERROR_RUNTIME:
            printf("[Runtime Error] %s\n", msg);
            break;
    }
}

char *readFile(const char *fileName) {
    FILE *f = fopen(fileName, "r");
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    rewind(f);
    char *script = malloc(fsize + 1);
    fread(script, 1, fsize, f);
    fclose(f);
    script[fsize] = 0;
    return script;
}

static void loadModuleComplete(WrenVM* vm, const char* module, WrenLoadModuleResult result) {
    if( result.source) free((void*)result.source);
}

WrenLoadModuleResult loadModule(WrenVM* vm, const char* name) {
    WrenLoadModuleResult result = {0};
    if (strcmp(name, "random") != 0 && strcmp(name, "meta") != 0) {
        result.onComplete = loadModuleComplete;
        char fullName[strlen(name) + 6];
        strcpy(fullName, name);
        strcat(fullName, ".wren");
        result.source = readFile(fullName);
    }
    return result;
}

int main(int argc, char **argv) {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    config.loadModuleFn = &loadModule;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "svd_embedded.wren";
    char *script = readFile(fileName);
    WrenInterpretResult result = wrenInterpret(vm, module, script);
    switch (result) {
        case WREN_RESULT_COMPILE_ERROR:
            printf("Compile Error!\n");
            break;
        case WREN_RESULT_RUNTIME_ERROR:
            printf("Runtime Error!\n");
            break;
        case WREN_RESULT_SUCCESS:
            break;
    }
    wrenFreeVM(vm);
    free(script);
    return 0;
}
