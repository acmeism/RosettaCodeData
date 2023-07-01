/* gcc rc_count_examples.c -o rc_count_examples -lcurl -lwren -lm  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include "wren.h"

struct MemoryStruct {
    char *memory;
    size_t size;
};

/* C <=> Wren interface functions */

static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp) {
    size_t realsize = size * nmemb;
    struct MemoryStruct *mem = (struct MemoryStruct *)userp;

    char *ptr = realloc(mem->memory, mem->size + realsize + 1);
    if(!ptr) {
        /* out of memory! */
        printf("not enough memory (realloc returned NULL)\n");
        return 0;
    }

    mem->memory = ptr;
    memcpy(&(mem->memory[mem->size]), contents, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
    return realsize;
}

void C_bufferAllocate(WrenVM* vm) {
    struct MemoryStruct *ms = (struct MemoryStruct *)wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct MemoryStruct));
    ms->memory = malloc(1);
    ms->size = 0;
}

void C_bufferFinalize(void* data) {
    struct MemoryStruct *ms = (struct MemoryStruct *)data;
    free(ms->memory);
}

void C_curlAllocate(WrenVM* vm) {
    CURL** pcurl = (CURL**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(CURL*));
    *pcurl = curl_easy_init();
}

void C_value(WrenVM* vm) {
    struct MemoryStruct *ms = (struct MemoryStruct *)wrenGetSlotForeign(vm, 0);
    wrenSetSlotString(vm, 0, ms->memory);
}

void C_easyPerform(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    curl_easy_perform(curl);
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
    } else if (opt < 20000) {
        if (opt == CURLOPT_WRITEDATA) {
            struct MemoryStruct *ms = (struct MemoryStruct *)wrenGetSlotForeign(vm, 2);
            curl_easy_setopt(curl, opt, (void *)ms);
        } else if (opt == CURLOPT_URL) {
            const char *url = wrenGetSlotString(vm, 2);
            curl_easy_setopt(curl, opt, url);
        }
    } else if (opt < 30000) {
        if (opt == CURLOPT_WRITEFUNCTION) {
            curl_easy_setopt(curl, opt, &WriteMemoryCallback);
        }
    }
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Buffer") == 0) {
            methods.allocate = C_bufferAllocate;
            methods.finalize = C_bufferFinalize;
        } else if (strcmp(className, "Curl") == 0) {
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
        if (strcmp(className, "Buffer") == 0) {
            if (!isStatic && strcmp(signature, "value") == 0)           return C_value;
        } else if (strcmp(className, "Curl") == 0) {
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
    const char* fileName = "rc_count_examples.wren";
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
