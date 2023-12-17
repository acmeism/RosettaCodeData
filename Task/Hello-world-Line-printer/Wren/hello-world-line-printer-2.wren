/* gcc Hello_world_Line_printer.c -o Hello_world_Line_printer -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_lprint(WrenVM* vm) {
    const char *arg = wrenGetSlotString(vm, 1);
    char command[strlen(arg) + 13];
    strcpy(command, "echo \"");
    strcat(command, arg);
    strcat(command, "\" | lp");
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
            if (isStatic && strcmp(signature, "lprint(_)") == 0)  return C_lprint;
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
    const char* fileName = "Hello_world_Line_printer.wren";
    char *script = readFile(fileName);
    WrenInterpretResult result = wrenInterpret(vm, module, script);
    wrenFreeVM(vm);
    free(script);
    return 0;
}
