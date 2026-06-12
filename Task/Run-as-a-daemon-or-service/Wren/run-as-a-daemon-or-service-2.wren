/* gcc Run_as_a_daemon_or_service.c -o dumper -lwren -lm */

#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include "wren.h"

char *fileName;

void C_fileName(WrenVM* vm) {
    wrenSetSlotString(vm, 0, fileName);
}

void C_open(WrenVM* vm) {
    const char *pathName = wrenGetSlotString(vm, 1);
    int flags = (int)wrenGetSlotDouble(vm, 2);
    mode_t mode = (mode_t)wrenGetSlotDouble(vm, 3);
    int fd = open(pathName, flags, mode);
    wrenSetSlotDouble(vm, 0, (double)fd);
}

void C_daemon(WrenVM* vm) {
    int nochdir = (int)wrenGetSlotDouble(vm, 1);
    int noclose = (int)wrenGetSlotDouble(vm, 2);
    int d = daemon(nochdir, noclose);
    wrenSetSlotDouble(vm, 0, (double)d);
}

void C_redirectStdout(WrenVM* vm) {
    int oldfd = (int)wrenGetSlotDouble(vm, 1);
    int newfd = (int)wrenGetSlotDouble(vm, 2);
    newfd = dup2(oldfd, newfd);
    wrenSetSlotDouble(vm, 0, (double)newfd);
}

void C_close(WrenVM* vm) {
    int fd = (int)wrenGetSlotDouble(vm, 1);
    int ret = close(fd);
    wrenSetSlotDouble(vm, 0, (double)ret);
}

void C_time(WrenVM* vm) {
    time_t t = time(NULL);
    wrenSetSlotDouble(vm, 0, (double)t);
}

void C_sleep(WrenVM* vm) {
    unsigned int seconds = (unsigned int) wrenGetSlotDouble(vm, 1);
    unsigned int ret = sleep(seconds);
    wrenSetSlotDouble(vm, 0, (double)ret);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "fileName") == 0)            return C_fileName;
            if (isStatic && strcmp(signature, "open(_,_,_)") == 0)         return C_open;
            if (isStatic && strcmp(signature, "daemon(_,_)") == 0)         return C_daemon;
            if (isStatic && strcmp(signature, "redirectStdout(_,_)") == 0) return C_redirectStdout;
            if (isStatic && strcmp(signature, "close(_)") == 0)            return C_close;
            if (isStatic && strcmp(signature, "time") == 0)                return C_time;
            if (isStatic && strcmp(signature, "sleep(_)") == 0)            return C_sleep;
        }
    }
    return NULL;
}

static void writeFn(WrenVM* vm, const char* text) {
    printf("%s", text);
    fflush(stdout); // as we're redirecting stdout to a file
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
    size_t ret = fread(script, 1, fsize, f);
    if (ret != fsize) printf("Error reading %s\n", fileName);
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
    fileName = argv[1];
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    config.loadModuleFn = &loadModule;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "Run_as_a_daemon_or_service.wren";
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
