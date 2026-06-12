/* gcc Using_a_speech_engine_to_highlight_words.c -o Using_a_speech_engine_to_highlight_words -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "wren.h"

void C_usleep(WrenVM* vm) {
    useconds_t usec = (useconds_t)wrenGetSlotDouble(vm, 1);
    usleep(usec);
}

void C_espeak(WrenVM* vm) {
    const char *arg = wrenGetSlotString(vm, 1);
    char command[strlen(arg) + 10];
    strcpy(command, "espeak \"");
    strcat(command, arg);
    strcat(command, "\"");
    system(command);
}

void C_flushStdout(WrenVM* vm) {
    fflush(stdout);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "usleep(_)") == 0)     return C_usleep;
            if (isStatic && strcmp(signature, "espeak(_)") == 0)     return C_espeak;
            if (isStatic && strcmp(signature, "flushStdout()") == 0) return C_flushStdout;
        }
    }
    return NULL;
}

static void writeFn(WrenVM* vm, const char* text) {
    printf("%s", text);
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
    config.bindForeignMethodFn = &bindForeignMethod;
    config.loadModuleFn = &loadModule;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "Using_a_speech_engine_to_highlight_words.wren";
    char *script = readFile(fileName);
    wrenInterpret(vm, module, script);
    wrenFreeVM(vm);
    free(script);
    return 0;
}
