/* gcc Speech_synthesis.c -o Speech_synthesis -lwren -lm */

#include <stdio.h>
#include <stdio_ext.h>
#include <stdlib.h>
#include <string.h>
#include "wren.h"

void C_getInput(WrenVM* vm) {
    int maxSize = (int)wrenGetSlotDouble(vm, 1) + 2;
    char input[maxSize];
    fgets(input, maxSize, stdin);
    __fpurge(stdin);
    input[strcspn(input, "\n")] = 0;
    wrenSetSlotString(vm, 0, (const char*)input);
}

void C_espeak(WrenVM* vm) {
    const char *arg = wrenGetSlotString(vm, 1);
    char command[strlen(arg) + 10];
    strcpy(command, "espeak \"");
    strcat(command, arg);
    strcat(command, "\"");
    system(command);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "getInput(_)") == 0) return C_getInput;
            if (isStatic && strcmp(signature, "espeak(_)") == 0) return C_espeak;
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

int main(int argc, char **argv) {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "Speech_synthesis.wren";
    char *script = readFile(fileName);
    wrenInterpret(vm, module, script);
    wrenFreeVM(vm);
    free(script);
    return 0;
}
