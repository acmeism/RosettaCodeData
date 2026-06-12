/* gcc IPC_via_named_pipe.c -o IPC_via_named_pipe -lpthread -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <pthread.h>
#include "wren.h"

/* C <=> Wren interface functions */

size_t tally = 0;

void C_make(WrenVM* vm) {
    const char *pathname = wrenGetSlotString(vm, 1);
    mode_t mode = (mode_t)wrenGetSlotDouble(vm, 2);
    int res = mkfifo(pathname, mode);
    wrenSetSlotDouble(vm, 0, (double)res);
}

void C_open(WrenVM* vm) {
    const char *pathname = wrenGetSlotString(vm, 1);
    int flags = (int)wrenGetSlotDouble(vm, 2);
    int fd = open(pathname, flags);
    if (fd < 0) {
        perror(NULL);
    }
    wrenSetSlotDouble(vm, 0, (double)fd);
}

void C_write(WrenVM* vm) {
   int fd = (int)wrenGetSlotDouble(vm, 1);
   const char *str = wrenGetSlotString(vm, 2);
   size_t count = (size_t)wrenGetSlotDouble(vm, 3);
   ssize_t res = write(fd, (const void *)str, count + 1);
   wrenSetSlotDouble(vm, 0, (double)res);
}

void C_read(WrenVM* vm) {
   int fd = (int)wrenGetSlotDouble(vm, 1);
   size_t nbyte = (size_t)wrenGetSlotDouble(vm, 2);
   char buf[nbyte];
   ssize_t res = read(fd, buf, nbyte);
   wrenSetSlotDouble(vm, 0, (double)res);
}

void C_close(WrenVM* vm) {
   int fd = (int)wrenGetSlotDouble(vm, 1);
   int res = close(fd);
   wrenSetSlotDouble(vm, 0, (double)res);
}

void C_usleep(WrenVM* vm) {
   useconds_t usec = (useconds_t)wrenGetSlotDouble(vm, 1);
   int res = usleep(usec);
   wrenSetSlotDouble(vm, 0, (double)res);
}

void C_getTally(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, (double)tally);
}

void C_setTally(WrenVM* vm) {
    size_t newTally = (size_t)wrenGetSlotDouble(vm, 1);
    tally = newTally;
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Fifo") == 0) {
            if (isStatic && strcmp(signature, "make(_,_)") == 0)    return C_make;
        } else if (strcmp(className, "File") == 0) {
            if (isStatic && strcmp(signature, "open(_,_)") == 0)    return C_open;
            if (isStatic && strcmp(signature, "write(_,_,_)") == 0) return C_write;
            if (isStatic && strcmp(signature, "read(_,_)") == 0)    return C_read;
            if (isStatic && strcmp(signature, "close(_)") == 0)     return C_close;
        } else if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "usleep(_)") == 0)    return C_usleep;
            if (isStatic && strcmp(signature, "tally") == 0)        return C_getTally;
            if (isStatic && strcmp(signature, "tally=(_)") == 0)    return C_setTally;
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

WrenVM *vm, *vm2;

void read_loop() {
    wrenEnsureSlots(vm, 1);
    wrenGetVariable(vm, "main", "Loops", 0);
    WrenHandle *method = wrenMakeCallHandle(vm, "read()");
    wrenCall(vm, method);
    wrenReleaseHandle(vm, method);
}

void* write_loop(void *a) {
    wrenEnsureSlots(vm2, 1);
    wrenGetVariable(vm2, "main", "Loops", 0);
    WrenHandle *method = wrenMakeCallHandle(vm2, "write()");
    wrenCall(vm2, method);
    wrenReleaseHandle(vm2, method);
}

int main(int argc, char **argv) {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    vm = wrenNewVM(&config);
    vm2 = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "IPC_via_named_pipe.wren";
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
    wrenInterpret(vm2, module, script);
    pthread_t pid;
    pthread_create(&pid, 0, write_loop, 0);
    read_loop();
    wrenFreeVM(vm);
    wrenFreeVM(vm2);
    free(script);
    return 0;
}
