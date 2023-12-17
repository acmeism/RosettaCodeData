#include <stdio.h>
#include <stdio_ext.h>
#include <stdlib.h>
#include <string.h>
#include <ftplib.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_init(WrenVM* vm) {
    FtpInit();
}

void C_ftpAllocate(WrenVM* vm) {
    netbuf *nbuf;
    const char *host = wrenGetSlotString(vm, 1);
    FtpConnect(host, &nbuf);
    netbuf** pnbuf = (netbuf**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(netbuf*));
    *pnbuf = nbuf;
}

void C_login(WrenVM* vm) {
    netbuf* nbuf = *(netbuf**)wrenGetSlotForeign(vm, 0);
    const char *user = wrenGetSlotString(vm, 1);
    const char *pass = wrenGetSlotString(vm, 2);
    FtpLogin(user, pass, nbuf);
}

void C_options(WrenVM* vm) {
    netbuf* nbuf = *(netbuf**)wrenGetSlotForeign(vm, 0);
    int opt = (int)wrenGetSlotDouble(vm, 1);
    long val = (long)wrenGetSlotDouble(vm, 2);
    FtpOptions(opt, val, nbuf);
}

void C_chdir(WrenVM* vm) {
    netbuf* nbuf = *(netbuf**)wrenGetSlotForeign(vm, 0);
    const char *path = wrenGetSlotString(vm, 1);
    FtpChdir(path, nbuf);
}

void C_dir(WrenVM* vm) {
    netbuf* nbuf = *(netbuf**)wrenGetSlotForeign(vm, 0);
    const char *outputFile = wrenGetSlotString(vm, 1);
    if (strlen(outputFile) == 0) outputFile = NULL;
    const char *path = wrenGetSlotString(vm, 2);
    FtpDir(outputFile, path, nbuf);
}

void C_get(WrenVM* vm) {
    netbuf* nbuf = *(netbuf**)wrenGetSlotForeign(vm, 0);
    const char *output = wrenGetSlotString(vm, 1);
    if (strlen(output) == 0) output = NULL;
    const char *path = wrenGetSlotString(vm, 2);
    char mode = (char)wrenGetSlotDouble(vm, 3);
    FtpGet(output, path, mode, nbuf);
}

void C_quit(WrenVM* vm) {
    netbuf* nbuf = *(netbuf**)wrenGetSlotForeign(vm, 0);
    FtpQuit(nbuf);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Ftp") == 0) {
            methods.allocate = C_ftpAllocate;
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
        if (strcmp(className, "Ftp") == 0) {
            if ( isStatic && strcmp(signature, "init()") == 0)       return C_init;
            if (!isStatic && strcmp(signature, "login(_,_)") == 0)   return C_login;
            if (!isStatic && strcmp(signature, "options(_,_)") == 0) return C_options;
            if (!isStatic && strcmp(signature, "chdir(_)") == 0)     return C_chdir;
            if (!isStatic && strcmp(signature, "dir(_,_)") == 0)     return C_dir;
            if (!isStatic && strcmp(signature, "get(_,_,_)") == 0)   return C_get;
            if (!isStatic && strcmp(signature, "quit()") == 0)       return C_quit;
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
    const char* fileName = "FTP.wren";
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
