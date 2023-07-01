/* gcc https.c -o https -lcurl -lwren -lm  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_curlAllocate(WrenVM* vm) {
    CURL** pcurl = (CURL**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(CURL*));
    *pcurl = curl_easy_init();
}

void C_easyPerform(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    CURLcode cc = curl_easy_perform(curl);
    wrenSetSlotDouble(vm, 0, (double)cc);
}

void C_easyCleanup(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    curl_easy_cleanup(curl);
}

void C_easySetOpt(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    CURLoption opt = (CURLoption)wrenGetSlotDouble(vm, 1);
    if (opt < 10000) {
        long lparam = (long)wrenGetSlotDouble(vm, 2);
        curl_easy_setopt(curl, opt, lparam);
    } else {
        if (opt == CURLOPT_URL) {
            const char *url = wrenGetSlotString(vm, 2);
            curl_easy_setopt(curl, opt, url);
        } else if (opt == CURLOPT_ERRORBUFFER) {
            char buffer[CURL_ERROR_SIZE];
            curl_easy_setopt(curl, opt, buffer);
        }
    }
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Curl") == 0) {
            methods.allocate = C_curlAllocate;
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
        if (strcmp(className, "Curl") == 0) {
            if (!isStatic && strcmp(signature, "easySetOpt(_,_)") == 0) return C_easySetOpt;
            if (!isStatic && strcmp(signature, "easyPerform()") == 0)   return C_easyPerform;
            if (!isStatic && strcmp(signature, "easyCleanup()") == 0)   return C_easyCleanup;
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
    const char* fileName = "https.wren";
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
