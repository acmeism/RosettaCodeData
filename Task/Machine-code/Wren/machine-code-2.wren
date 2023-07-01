#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include "wren.h"

unsigned char rmc_helper(const char *code, unsigned char a, unsigned char b, int l) {
    void *buf;
    unsigned char c;

    /* copy code to executable buffer */
    buf = mmap (0, l, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANON, -1, 0);
    memcpy(buf, code, l);

    /* run code */
    c = ((unsigned char (*) (unsigned char, unsigned char))buf)(a, b);

    /* free buffer */
    munmap(buf, l);

    /* return result to caller */
    return c;
}

void C_runMachineCode(WrenVM* vm) {
    /* unpack arguments passed from Wren */
    int *len;
    const char *code = wrenGetSlotBytes(vm, 1, len);
    unsigned char a = (unsigned char)wrenGetSlotDouble(vm, 2);
    unsigned char b = (unsigned char)wrenGetSlotDouble(vm, 3);

    /* obtain result */
    unsigned char c = rmc_helper(code, a, b, *len);

    /* return result to Wren */
    wrenSetSlotDouble(vm, 0, (double)c);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "runMachineCode(_,_,_)") == 0) {
                return C_runMachineCode;
            }
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

int main() {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "machine_code.wren";
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
