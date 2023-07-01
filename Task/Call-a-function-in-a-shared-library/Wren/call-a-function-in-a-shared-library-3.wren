/* gcc call_shared_library_function.c -o call_shared_library_function -ldl -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_dlAllocate(WrenVM* vm) {
    const char *file = wrenGetSlotString(vm, 1);
    int mode = (int)wrenGetSlotDouble(vm, 2);
    void *imglib = dlopen(file, mode);
    if (imglib == NULL) wrenSetSlotNull(vm, 0);
    void** pimglib = (void**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(void*));
    *pimglib = imglib;
}

void C_call(WrenVM* vm) {
    void *imglib = *(void**)wrenGetSlotForeign(vm, 0);
    const char *symbol = wrenGetSlotString(vm, 1);
    const char *arg = wrenGetSlotString(vm, 2);
    int (*extopenimage)(const char *);
    extopenimage = dlsym(imglib, symbol);
    int imghandle = extopenimage(arg);
    wrenSetSlotDouble(vm, 0, (double)imghandle);
}

void C_close(WrenVM* vm) {
    void *imglib = *(void**)wrenGetSlotForeign(vm, 0);
    dlclose(imglib);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "DL") == 0) {
            methods.allocate = C_dlAllocate;
        }
    }
    return methods;
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "DL") == 0) {
            if (!isStatic && strcmp(signature, "call(_,_)") == 0) return C_call;
            if (!isStatic && strcmp(signature, "close()") == 0)   return C_close;
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

int main(int argc, char **argv) {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignClassFn = &bindForeignClass;
    config.bindForeignMethodFn = &bindForeignMethod;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "call_shared_library_function.wren";
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
