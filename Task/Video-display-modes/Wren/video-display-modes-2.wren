#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "wren.h"

void C_xrandr(WrenVM* vm) {
     const char *arg = wrenGetSlotString(vm, 1);
     char command[strlen(arg) + 8];
     strcpy(command, "xrandr ");
     strcat(command, arg);
     system(command);
}

void C_usleep(WrenVM* vm) {
    useconds_t usec = (useconds_t)wrenGetSlotDouble(vm, 1);
    usleep(usec);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "xrandr(_)") == 0) return C_xrandr;
            if (isStatic && strcmp(signature, "usleep(_)") == 0) return C_usleep;
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
    const char* fileName = "video_display_modes.wren";
    char *script = readFile(fileName);
    wrenInterpret(vm, module, script);
    wrenFreeVM(vm);
    free(script);
    return 0;
}
