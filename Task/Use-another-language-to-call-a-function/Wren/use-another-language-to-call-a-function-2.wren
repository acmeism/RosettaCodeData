/* gcc Use_another_language_to_call_a_function.c -o Use_another_language_to_call_a_function -lwren -lm */

#include <stdio.h>
#include "wren.h"

char *script;
WrenVM * vm;

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    return NULL; // nothing needed here
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

int configWrenVM() {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "Use_another_language_to_call_a_function.wren";
    script = readFile(fileName);
    WrenInterpretResult result = wrenInterpret(vm, module, script);
    switch (result) {
        case WREN_RESULT_COMPILE_ERROR:
            printf("Compile Error!\n");
            return -1;
        case WREN_RESULT_RUNTIME_ERROR:
            printf("Runtime Error!\n");
            return -1;
        case WREN_RESULT_SUCCESS:
            break;
    }
    return 0;
}

int Query(char *Data, size_t *Length) {
    int i, r;
    wrenEnsureSlots(vm, 4);

    // create list for Data, fill with zeros and put in slot 1
    wrenSetSlotNewList(vm, 1);
    wrenSetSlotDouble(vm, 2, 0.0);
    for (i = 0; i < *Length; ++i) wrenInsertInList(vm, 1, i, 2);

    // create list for Length and put in slot 2
    wrenSetSlotNewList(vm, 2);
    wrenSetSlotDouble(vm, 3, (double)*Length);
    wrenInsertInList(vm, 2, 0, 3);

    // get handle to Wren's query method
    WrenHandle* method = wrenMakeCallHandle(vm, "query(_,_)");

    // get its class and put in slot 0
    wrenGetVariable(vm, "main", "RCQuery", 0);

    // call the Wren method
    wrenCall(vm, method);

    // get the result and check it's 1
    r = (int)wrenGetSlotDouble(vm, 0);
    if (r) {
        // get the length of the string from slot 2
        wrenGetListElement(vm, 2, 0, 3);
        *Length = (int)wrenGetSlotDouble(vm, 3);

        // copy the bytes from the list in slot 1 to the C buffer
        for (i = 0; i < *Length; ++i) {
            wrenGetListElement(vm, 1, i, 3);
            Data[i] = (char)wrenGetSlotDouble(vm, 3);
        }
    }
    return r;
}

int main() {
    int e = configWrenVM();
    if (!e) {
        char Buffer [1024];
        size_t Size = sizeof(Buffer);
        if (0 == Query(Buffer, &Size)) {
            printf ("failed to call Query\n");
            e = 1;
        } else {
            char * Ptr = Buffer;
            while (Size-- > 0) putchar (*Ptr++);
            putchar ('\n');
        }
    }
    wrenFreeVM(vm);
    free(script);
    return e;
}
