/* gcc Terminal_control_Positional_read.c -o Terminal_control_Positional_read -lncurses -lwren -lm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ncurses.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_windowAllocate(WrenVM* vm) {
    WINDOW** pwin = (WINDOW**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(WINDOW*));
    *pwin = initscr();
}

void C_addstr(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    const char *str = wrenGetSlotString(vm, 1);
    waddstr(win, str);
}

void C_inch(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    int y = (int)wrenGetSlotDouble(vm, 1);
    int x = (int)wrenGetSlotDouble(vm, 2);
    char c = (char)mvwinch(win, y, x);
    char s[2] = "\0";
    sprintf(s, "%c", c);
    wrenSetSlotString(vm, 0, s);
}

void C_move(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    int y = (int)wrenGetSlotDouble(vm, 1);
    int x = (int)wrenGetSlotDouble(vm, 2);
    wmove(win, y, x);
}

void C_refresh(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    wrefresh(win);
}

void C_getch(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    wgetch(win);
}

void C_delwin(WrenVM* vm) {
    WINDOW* win = *(WINDOW**)wrenGetSlotForeign(vm, 0);
    delwin(win);
}

void C_endwin(WrenVM* vm) {
    endwin();
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
            if (!isStatic && strcmp(signature, "addstr(_)") == 0) return C_addstr;
            if (!isStatic && strcmp(signature, "inch(_,_)") == 0) return C_inch;
            if (!isStatic && strcmp(signature, "move(_,_)") == 0) return C_move;
            if (!isStatic && strcmp(signature, "refresh()") == 0) return C_refresh;
            if (!isStatic && strcmp(signature, "getch()") == 0)   return C_getch;
            if (!isStatic && strcmp(signature, "delwin()") == 0)  return C_delwin;
        } else if (strcmp(className, "Ncurses") == 0) {
            if ( isStatic && strcmp(signature, "endwin()") == 0)  return C_endwin;
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
    const char* fileName = "Terminal_control_Positional_read.wren";
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
