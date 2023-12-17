#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_displayAllocate(WrenVM* vm) {
    Display** pdisplay = (Display**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(Display*));
    const char *displayName = wrenGetSlotString(vm, 1);
    if (displayName == "") {
        *pdisplay = XOpenDisplay(NULL);
    } else {
        *pdisplay = XOpenDisplay(displayName);
    }
}

void C_eventAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(XEvent));
}

void C_eventType(WrenVM* vm) {
    XEvent e = *(XEvent *)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)e.type);
}

void C_defaultRootWindow(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    Window w = DefaultRootWindow(display);
    wrenSetSlotDouble(vm, 0, (double)w);
}

void C_grabKey(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    int keycode = (int)wrenGetSlotDouble(vm, 1);
    unsigned int modifiers = (unsigned int)wrenGetSlotDouble(vm, 2);
    Window w = (Window)wrenGetSlotDouble(vm, 3);
    Bool owner_events = (Bool)wrenGetSlotBool(vm, 4);
    int pointer_mode = (int)wrenGetSlotDouble(vm, 5);
    int keyboard_mode = (int)wrenGetSlotDouble(vm, 6);
    XGrabKey(display, keycode, modifiers, w, owner_events, pointer_mode, keyboard_mode);
}

void C_ungrabKey(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    int keycode = (int)wrenGetSlotDouble(vm, 1);
    unsigned int modifiers = (unsigned int)wrenGetSlotDouble(vm, 2);
    Window w = (Window)wrenGetSlotDouble(vm, 3);
    XUngrabKey(display, keycode, modifiers, w);
}

void C_keysymToKeycode(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    KeySym k = (KeySym)wrenGetSlotDouble(vm, 1);
    KeyCode code = XKeysymToKeycode(display, k);
    wrenSetSlotDouble(vm, 0, (double)code);
}

void C_closeDisplay(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    XCloseDisplay(display);
}

void C_nextEvent(WrenVM* vm) {
   Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
   XEvent* pe = (XEvent*)wrenGetSlotForeign(vm, 1);
   XNextEvent(display, pe);
}

void C_stringToKeysym(WrenVM* vm) {
    char *string = (char *)wrenGetSlotString(vm, 1);
    KeySym k = XStringToKeysym(string);
    wrenSetSlotDouble(vm, 0, (double)k);
}

void C_lookupKeysym(WrenVM* vm) {
    XKeyEvent *pke = (XKeyEvent*)wrenGetSlotForeign(vm, 1);
    int index = (int)wrenGetSlotDouble(vm, 2);
    KeySym k = XLookupKeysym(pke, index);
    wrenSetSlotDouble(vm, 0, (double)k);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.finalize = NULL;
    if (strcmp(className, "XDisplay") == 0) {
        methods.allocate = C_displayAllocate;
    } else if (strcmp(className, "XEvent") == 0) {
        methods.allocate = C_eventAllocate;
    } else {
        methods.allocate = NULL;
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
        if (strcmp(className, "XEvent") == 0) {
            if (!isStatic && strcmp(signature, "eventType") == 0)              return C_eventType;
        } else if (strcmp(className, "XDisplay") == 0) {
            if (!isStatic && strcmp(signature, "defaultRootWindow()") == 0)    return C_defaultRootWindow;
            if (!isStatic && strcmp(signature, "grabKey(_,_,_,_,_,_)") == 0)   return C_grabKey;
            if (!isStatic && strcmp(signature, "ungrabKey(_,_,_)") == 0)       return C_ungrabKey;
            if (!isStatic && strcmp(signature, "keysymToKeycode(_)") == 0)     return C_keysymToKeycode;
            if (!isStatic && strcmp(signature, "closeDisplay()") == 0)         return C_closeDisplay;
            if (!isStatic && strcmp(signature, "nextEvent(_)") == 0)           return C_nextEvent;
        } else if (strcmp(className, "X") == 0) {
            if (isStatic && strcmp(signature, "stringToKeysym(_)") == 0)       return C_stringToKeysym;
            if (isStatic && strcmp(signature, "lookupKeysym(_,_)") == 0)       return C_lookupKeysym;
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
    const char* fileName = "Keyboard_macros.wren";
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
