/* gcc Create_an_object_at_a_given_address.c -o Create_an_object_at_a_given_address -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_integerAllocate(WrenVM* vm) {
    long *pi = (long *)wrenSetSlotNewForeign(vm, 0, 0, sizeof(long));
    long i = (long)wrenGetSlotDouble(vm, 1);
    *pi = i;
}

void C_value(WrenVM* vm) {
    long i = *(long *)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)i);
}

void C_setValue(WrenVM* vm) {
    long *pi = (long *)wrenGetSlotForeign(vm, 0);
    long i = (long)wrenGetSlotDouble(vm, 1);
    *pi = i;
}

void C_address(WrenVM* vm) {
    long *pi = (long *)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)(unsigned long long)pi);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Integer") == 0) {
            methods.allocate = C_integerAllocate;
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
        if (strcmp(className, "Integer") == 0) {
            if (!isStatic && strcmp(signature, "value") == 0)     return C_value;
            if (!isStatic && strcmp(signature, "value=(_)") == 0) return C_setValue;
            if (!isStatic && strcmp(signature, "address") == 0)   return C_address;
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
    config.bindForeignClassFn = &bindForeignClass;
    config.bindForeignMethodFn = &bindForeignMethod;
    config.loadModuleFn = &loadModule;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "Create_an_object_at_a_given_address.wren";
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
