/* gcc snake.c -o snake -lncurses -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ncurses.h>
#include <unistd.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_windowAllocate(WrenVM* vm) {
    WINDOW** pwin = (WINDOW**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(WINDOW*));
    *pwin = initscr();
}

void C_nodelay(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    bool bf = wrenGetSlotBool(vm, 1);
    nodelay(win, bf);
}

void C_cbreak(WrenVM* vm) {
    cbreak();
}

void C_noecho(WrenVM* vm) {
    noecho();
}

void C_refresh(WrenVM* vm) {
    refresh();
}

void C_getch(WrenVM* vm) {
    int ch = getch();
    wrenSetSlotDouble(vm, 0, (double)ch);
}

void C_mvaddch(WrenVM* vm) {
    int y = (int)wrenGetSlotDouble(vm, 1);
    int x = (int)wrenGetSlotDouble(vm, 2);
    const chtype ch = (const chtype)wrenGetSlotDouble(vm, 3);
    mvaddch(y, x, ch);
}

void C_endwin(WrenVM* vm) {
    endwin();
}

void C_usleep(WrenVM* vm) {
    useconds_t usec = (useconds_t)wrenGetSlotDouble(vm, 1);
    usleep(usec);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Window") == 0) {
            methods.allocate = C_windowAllocate;
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
        if (strcmp(className, "Window") == 0) {
            if (!isStatic && strcmp(signature, "nodelay(_)") == 0)    return C_nodelay;
        } else if (strcmp(className, "Ncurses") == 0) {
            if (isStatic && strcmp(signature, "cbreak()") == 0)       return C_cbreak;
            if (isStatic && strcmp(signature, "noecho()") == 0)       return C_noecho;
            if (isStatic && strcmp(signature, "refresh()") == 0)      return C_refresh;
            if (isStatic && strcmp(signature, "getch()") == 0)        return C_getch;
            if (isStatic && strcmp(signature, "mvaddch(_,_,_)") == 0) return C_mvaddch;
            if (isStatic && strcmp(signature, "endwin()") == 0)       return C_endwin;
        } else if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "usleep(_)") == 0)      return C_usleep;
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
    const char* fileName = "snake.wren";
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
