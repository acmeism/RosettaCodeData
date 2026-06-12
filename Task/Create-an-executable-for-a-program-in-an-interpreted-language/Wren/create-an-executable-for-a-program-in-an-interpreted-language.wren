#include <stdio.h>
#include "wren.h"

static void writeFn(WrenVM* vm, const char* text) {
    printf("%s", text);
}

int main(int argc, char **argv) {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    char *script = "for (i in 5..0) System.print(i)"; /* Wren source code */
    WrenInterpretResult result = wrenInterpret(vm, module, script);
    wrenFreeVM(vm);
    return 0;
}
