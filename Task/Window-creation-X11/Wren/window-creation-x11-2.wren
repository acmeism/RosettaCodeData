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

void C_gcAllocate(WrenVM* vm) {
    GC *pgc = (GC *)wrenSetSlotNewForeign(vm, 0, 0, sizeof(GC));
    Display* display = *(Display**)wrenGetSlotForeign(vm, 1);
    int s = (int)wrenGetSlotDouble(vm, 2);
    *pgc = DefaultGC(display, s);
}

void C_eventAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(XEvent));
}

void C_eventType(WrenVM* vm) {
    XEvent e = *(XEvent *)wrenGetSlotForeign(vm, 0);
    wrenSetSlotDouble(vm, 0, (double)e.type);
}

void C_defaultScreen(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    int screenNumber = DefaultScreen(display);
    wrenSetSlotDouble(vm, 0, (double)screenNumber);
}

void C_rootWindow(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    int screenNumber = (int)wrenGetSlotDouble(vm, 1);
    Window w = RootWindow(display, screenNumber);
    wrenSetSlotDouble(vm, 0, (double)w);
}

void C_blackPixel(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    int screenNumber = (int)wrenGetSlotDouble(vm, 1);
    unsigned long p = BlackPixel(display, screenNumber);
    wrenSetSlotDouble(vm, 0, (double)p);
}

void C_whitePixel(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    int screenNumber = (int)wrenGetSlotDouble(vm, 1);
    unsigned long p = WhitePixel(display, screenNumber);
    wrenSetSlotDouble(vm, 0, (double)p);
}

void C_selectInput(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    Window w = (Window)wrenGetSlotDouble(vm, 1);
    long eventMask = (long)wrenGetSlotDouble(vm, 2);
    XSelectInput(display, w, eventMask);
}

void C_mapWindow(WrenVM* vm) {
    Display* display = *(Display**)wrenGetSlotForeign(vm, 0);
    Window w = (Window)wrenGetSlotDouble(vm, 1);
    XMapWindow(display, w);
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

void C_createSimpleWindow(WrenVM* vm) {
    Display *display         = *(Display**)wrenGetSlotForeign(vm, 0);
    Window parent            = (Window)wrenGetSlotDouble(vm, 1);
    int x                    = (int)wrenGetSlotDouble(vm, 2);
    int y                    = (int)wrenGetSlotDouble(vm, 3);
    unsigned int width       = (unsigned int)wrenGetSlotDouble(vm, 4);
    unsigned int height      = (unsigned int)wrenGetSlotDouble(vm, 5);
    unsigned int borderWidth = (unsigned int)wrenGetSlotDouble(vm, 6);
    unsigned long border     = (unsigned long)wrenGetSlotDouble(vm, 7);
    unsigned long background = (unsigned long)wrenGetSlotDouble(vm, 8);
    Window w = XCreateSimpleWindow(display, parent, x, y, width, height, borderWidth, border, background);
    wrenSetSlotDouble(vm, 0, (double)w);
}

void C_fillRectangle(WrenVM* vm) {
    Display *display    = *(Display**)wrenGetSlotForeign(vm, 0);
    Drawable d          = (Drawable)wrenGetSlotDouble(vm, 1);
    GC gc               = *(GC *)wrenGetSlotForeign(vm, 2);
    int x               = (int)wrenGetSlotDouble(vm, 3);
    int y               = (int)wrenGetSlotDouble(vm, 4);
    unsigned int width  = (unsigned int)wrenGetSlotDouble(vm, 5);
    unsigned int height = (unsigned int)wrenGetSlotDouble(vm, 6);
    XFillRectangle(display, d, gc, x, y, width, height);
}

void C_drawString(WrenVM* vm) {
    Display *display    = *(Display**)wrenGetSlotForeign(vm, 0);
    Drawable d          = (Drawable)wrenGetSlotDouble(vm, 1);
    GC gc               = *(GC *)wrenGetSlotForeign(vm, 2);
    int x               = (int)wrenGetSlotDouble(vm, 3);
    int y               = (int)wrenGetSlotDouble(vm, 4);
    const char *string  = wrenGetSlotString(vm, 5);
    int length          = (int)wrenGetSlotDouble(vm, 6);
    XDrawString(display, d, gc, x, y, string, length);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.finalize = NULL;
    if (strcmp(className, "XDisplay") == 0) {
        methods.allocate = C_displayAllocate;
    } else if (strcmp(className, "XGC") == 0) {
        methods.allocate = C_gcAllocate;
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
            if (!isStatic && strcmp(signature, "eventType") == 0)        return C_eventType;
        } else if (strcmp(className, "XDisplay") == 0) {
            if (!isStatic && strcmp(signature, "defaultScreen()") == 0)  return C_defaultScreen;
            if (!isStatic && strcmp(signature, "rootWindow(_)") == 0)    return C_rootWindow;
            if (!isStatic && strcmp(signature, "blackPixel(_)") == 0)    return C_blackPixel;
            if (!isStatic && strcmp(signature, "whitePixel(_)") == 0)    return C_whitePixel;
            if (!isStatic && strcmp(signature, "selectInput(_,_)") == 0) return C_selectInput;
            if (!isStatic && strcmp(signature, "mapWindow(_)") == 0)     return C_mapWindow;
            if (!isStatic && strcmp(signature, "closeDisplay()") == 0)   return C_closeDisplay;
            if (!isStatic && strcmp(signature, "nextEvent(_)") == 0)     return C_nextEvent;
            if (!isStatic && strcmp(signature, "createSimpleWindow(_,_,_,_,_,_,_,_)") == 0) return C_createSimpleWindow;
            if (!isStatic && strcmp(signature, "fillRectangle(_,_,_,_,_,_)") == 0) return C_fillRectangle;
            if (!isStatic && strcmp(signature, "drawString(_,_,_,_,_,_)") == 0) return C_drawString;
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
    const char* fileName = "window_creation_x11.wren";
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
