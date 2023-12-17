/* gcc File_modification_time.c -o File_modification_time -lwren -lm */

#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <utime.h>
#include "wren.h"

/* Stat functions */

void Stat_allocate(WrenVM* vm) {
    struct stat *pStat = (struct stat*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct stat));
    const char *filename = wrenGetSlotString(vm, 1);
    if (stat(filename, pStat) < 0) {
        perror(filename);
        exit(1);
    }
}

void Stat_atime(WrenVM* vm) {
    struct stat *pStat = (struct stat*)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)pStat->st_atime);
}

void Stat_mtime(WrenVM* vm) {
    struct stat *pStat = (struct stat*)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)pStat->st_mtime);
}

/* Utimbuf functions */

void Utimbuf_allocate(WrenVM* vm) {
    struct utimbuf *pUtimbuf = (struct utimbuf*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct utimbuf));
    time_t actime = (time_t)wrenGetSlotDouble(vm, 1);
    if (!actime) actime = time(NULL);
    pUtimbuf->actime = actime;
    time_t modtime = (time_t)wrenGetSlotDouble(vm, 2);
    if (!modtime) modtime = time(NULL);
    pUtimbuf->modtime = modtime;
}

void Utimbuf_utime(WrenVM* vm) {
    const struct utimbuf *pUtimbuf = (const struct utimbuf*)wrenGetSlotForeign(vm, 0);
    const char *filename = wrenGetSlotString(vm, 1);
    int res = utime(filename, pUtimbuf);
    wrenSetSlotDouble(vm, 0, (double)res);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Stat") == 0) {
            methods.allocate = Stat_allocate;
        } else if (strcmp(className, "Utimbuf") == 0) {
            methods.allocate = Utimbuf_allocate;
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
        if (strcmp(className, "Stat") == 0) {
            if(!isStatic && strcmp(signature, "atime") == 0) return Stat_atime;
            if(!isStatic && strcmp(signature, "mtime") == 0) return Stat_mtime;
        } else if (strcmp(className, "Utimbuf") == 0) {
            if(!isStatic && strcmp(signature, "utime(_)") == 0) return Utimbuf_utime;
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
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignClassFn = &bindForeignClass;
    config.bindForeignMethodFn = &bindForeignMethod;
    config.loadModuleFn = &loadModule;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "File_modification_time.wren";
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
