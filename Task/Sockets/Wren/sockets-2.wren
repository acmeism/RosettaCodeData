#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_addrInfoAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct addrinfo));
}

void C_addrInfoPtrAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct addrinfo*));
}

void C_sockAddrPtrAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct sockaddr*));
}

void C_getAddrInfo(WrenVM* vm) {
    const char *name = wrenGetSlotString(vm, 1);
    const char *service = wrenGetSlotString(vm, 2);
    const struct addrinfo *req = (const struct addrinfo *)wrenGetSlotForeign(vm, 3);
    struct addrinfo** ppai = (struct addrinfo**)wrenGetSlotForeign(vm, 4);
    int status = getaddrinfo(name, service, req, ppai);
    wrenSetSlotDouble(vm, 0, (double)status);
}

void C_family(WrenVM* vm) {
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)(pai->ai_family));
}

void C_setFamily(WrenVM* vm) {
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    int f = (int)wrenGetSlotDouble(vm, 1);
    pai->ai_family = f;
}

void C_sockType(WrenVM* vm) {
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)(pai->ai_socktype));
}

void C_setSockType(WrenVM* vm) {
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    int type = (int)wrenGetSlotDouble(vm, 1);
    pai->ai_socktype = type;
}

void C_protocol(WrenVM* vm) {
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)(pai->ai_protocol));
}

void C_addr(WrenVM* vm) {
    wrenEnsureSlots(vm, 2);
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    wrenGetVariable(vm, "main", "SockAddrPtr", 1);
    struct sockaddr **ppsa = (struct sockaddr**)wrenSetSlotNewForeign(vm, 0, 1, sizeof(struct sockaddr*));
    *ppsa = pai->ai_addr;
}

void C_addrLen(WrenVM* vm) {
    struct addrinfo* pai = (struct addrinfo*)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)(pai->ai_addrlen));
}

void C_deref(WrenVM* vm) {
    wrenEnsureSlots(vm, 2);
    struct addrinfo** ppai = (struct addrinfo**)wrenGetSlotForeign(vm, 0);
    wrenGetVariable(vm, "main", "AddrInfo", 1);
    struct addrinfo *pai = (struct addrinfo*)wrenSetSlotNewForeign(vm, 0, 1, sizeof(struct addrinfo));
    *pai = **ppai;
}

void C_free(WrenVM* vm) {
    struct addrinfo* pai = *(struct addrinfo**)wrenGetSlotForeign(vm, 0);
    freeaddrinfo(pai);
}

void C_create(WrenVM* vm) {
    int domain   = (int)wrenGetSlotDouble(vm, 1);
    int type     = (int)wrenGetSlotDouble(vm, 2);
    int protocol = (int)wrenGetSlotDouble(vm, 3);
    int fd = socket(domain, type, protocol);
    wrenSetSlotDouble(vm, 0, (double)fd);
}

void C_connect(WrenVM* vm) {
    int fd  = (int)wrenGetSlotDouble(vm, 1);
    __CONST_SOCKADDR_ARG *psa = (__CONST_SOCKADDR_ARG *)wrenGetSlotForeign(vm, 2);
    socklen_t len = (socklen_t)wrenGetSlotDouble(vm, 3);
    int status = connect(fd, *psa, len);
    wrenSetSlotDouble(vm, 0, (double)status);
}

void C_send(WrenVM* vm) {
    int fd  = (int)wrenGetSlotDouble(vm, 1);
    const char *buf = (const char *)wrenGetSlotString(vm, 2);
    size_t n = (size_t)wrenGetSlotDouble(vm, 3);
    int flags = (int)wrenGetSlotDouble(vm, 4);
    ssize_t size = send(fd, (const void*)buf, n, flags);
    wrenSetSlotDouble(vm, 0, (double)size);
}

void C_close(WrenVM* vm) {
    int fd  = (int)wrenGetSlotDouble(vm, 1);
    int status = close(fd);
    wrenSetSlotDouble(vm, 0, (double)status);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "AddrInfo") == 0) {
            methods.allocate = C_addrInfoAllocate;
        } else if (strcmp(className, "AddrInfoPtr") == 0) {
            methods.allocate = C_addrInfoPtrAllocate;
        } else if (strcmp(className, "SockAddPtr") == 0) {
            methods.allocate = C_sockAddrPtrAllocate;
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
        if (strcmp(className, "AddrInfo") == 0) {
            if ( isStatic && strcmp(signature, "getAddrInfo(_,_,_,_)") == 0) return C_getAddrInfo;
            if (!isStatic && strcmp(signature, "family") == 0)               return C_family;
            if (!isStatic && strcmp(signature, "family=(_)") == 0)           return C_setFamily;
            if (!isStatic && strcmp(signature, "sockType") == 0)             return C_sockType;
            if (!isStatic && strcmp(signature, "sockType=(_)") == 0)         return C_setSockType;
            if (!isStatic && strcmp(signature, "protocol") == 0)             return C_protocol;
            if (!isStatic && strcmp(signature, "addr") == 0)                 return C_addr;
            if (!isStatic && strcmp(signature, "addrLen") == 0)              return C_addrLen;
        } else if (strcmp(className, "AddrInfoPtr") == 0) {
            if (!isStatic && strcmp(signature, "deref") == 0)                return C_deref;
            if (!isStatic && strcmp(signature, "free()") == 0)               return C_free;
        } else if (strcmp(className, "Socket") == 0) {
            if ( isStatic && strcmp(signature, "create(_,_,_)") == 0)        return C_create;
            if ( isStatic && strcmp(signature, "connect(_,_,_)") == 0)       return C_connect;
            if ( isStatic && strcmp(signature, "send(_,_,_,_)") == 0)        return C_send;
            if ( isStatic && strcmp(signature, "close(_)") == 0)             return C_close;
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
    const char* fileName = "sockets2.wren";
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
