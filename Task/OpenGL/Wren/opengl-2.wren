#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <GL/gl.h>
#include <GL/freeglut.h>
#include "wren.h"

/* C <=> Wren interface functions */

WrenVM *vm;

const char *displayClass, *displayMethod, *reshapeClass, *reshapeMethod;

void display() {
    wrenEnsureSlots(vm, 1);
    wrenGetVariable(vm, "main", displayClass, 0);
    WrenHandle *method = wrenMakeCallHandle(vm, displayMethod);
    wrenCall(vm, method);
    wrenReleaseHandle(vm, method);
}

void reshape(int width, int height) {
    wrenEnsureSlots(vm, 3);
    wrenGetVariable(vm, "main", reshapeClass, 0);
    WrenHandle *method = wrenMakeCallHandle(vm, reshapeMethod);
    wrenSetSlotDouble(vm, 1, (double)width);
    wrenSetSlotDouble(vm, 2, (double)height);
    wrenCall(vm, method);
    wrenReleaseHandle(vm, method);
}

void C_clearColor(WrenVM* vm) {
    GLclampf red   = (GLclampf)wrenGetSlotDouble(vm, 1);
    GLclampf green = (GLclampf)wrenGetSlotDouble(vm, 2);
    GLclampf blue  = (GLclampf)wrenGetSlotDouble(vm, 3);
    GLclampf alpha = (GLclampf)wrenGetSlotDouble(vm, 4);
    glClearColor(red, green, blue, alpha);
}

void C_clear(WrenVM* vm) {
    GLbitfield mask = (GLbitfield)wrenGetSlotDouble(vm, 1);
    glClear(mask);
}

void C_shadeModel(WrenVM* vm) {
    GLenum mode = (GLenum)wrenGetSlotDouble(vm, 1);
    glShadeModel(mode);
}

void C_loadIdentity(WrenVM* vm) {
    glLoadIdentity();
}

void C_translatef(WrenVM* vm) {
    GLfloat x = (GLfloat)wrenGetSlotDouble(vm, 1);
    GLfloat y = (GLfloat)wrenGetSlotDouble(vm, 2);
    GLfloat z = (GLfloat)wrenGetSlotDouble(vm, 3);
    glTranslatef(x, y, z);
}

void C_begin(WrenVM* vm) {
    GLenum mode = (GLenum)wrenGetSlotDouble(vm, 1);
    glBegin(mode);
}

void C_color3f(WrenVM* vm) {
    GLfloat red   = (GLfloat)wrenGetSlotDouble(vm, 1);
    GLfloat green = (GLfloat)wrenGetSlotDouble(vm, 2);
    GLfloat blue  = (GLfloat)wrenGetSlotDouble(vm, 3);
    glColor3f(red, green, blue);
}

void C_vertex2f(WrenVM* vm) {
    GLfloat x = (GLfloat)wrenGetSlotDouble(vm, 1);
    GLfloat y = (GLfloat)wrenGetSlotDouble(vm, 2);
    glVertex2f(x, y);
}

void C_end(WrenVM* vm) {
    glEnd();
}

void C_flush(WrenVM* vm) {
    glFlush();
}

void C_viewport(WrenVM* vm) {
    GLint x        = (GLint)  wrenGetSlotDouble(vm, 1);
    GLint y        = (GLint)  wrenGetSlotDouble(vm, 2);
    GLsizei width  = (GLsizei)wrenGetSlotDouble(vm, 3);
    GLsizei height = (GLsizei)wrenGetSlotDouble(vm, 4);
    glViewport(x, y, width, height);
}

void C_matrixMode(WrenVM* vm) {
    GLenum mode = (GLenum)wrenGetSlotDouble(vm, 1);
    glMatrixMode(mode);
}

void C_ortho(WrenVM* vm) {
    GLdouble left    = (GLdouble)wrenGetSlotDouble(vm, 1);
    GLdouble right   = (GLdouble)wrenGetSlotDouble(vm, 2);
    GLdouble bottom  = (GLdouble)wrenGetSlotDouble(vm, 3);
    GLdouble top     = (GLdouble)wrenGetSlotDouble(vm, 4);
    GLdouble nearVal = (GLdouble)wrenGetSlotDouble(vm, 5);
    GLdouble farVal  = (GLdouble)wrenGetSlotDouble(vm, 6);
    glOrtho(left, right, bottom, top, nearVal, farVal);
}

void C_initWindowSize(WrenVM* vm) {
    int width  = (int)wrenGetSlotDouble(vm, 1);
    int height = (int)wrenGetSlotDouble(vm, 2);
    glutInitWindowSize(width, height);
}

void C_createWindow(WrenVM* vm) {
    const char *name = wrenGetSlotString(vm, 1);
    glutCreateWindow(name);
}

void C_displayFunc(WrenVM* vm) {
    displayClass  = wrenGetSlotString(vm, 1);
    displayMethod = wrenGetSlotString(vm, 2);
    glutDisplayFunc(&display);
}

void C_reshapeFunc(WrenVM* vm) {
    reshapeClass  = wrenGetSlotString(vm, 1);
    reshapeMethod = wrenGetSlotString(vm, 2);
    glutReshapeFunc(&reshape);
}

void C_setOption(WrenVM* vm) {
    GLenum eWhat = (GLenum)wrenGetSlotDouble(vm, 1);
    int value    = (int)wrenGetSlotDouble(vm, 2);
    glutSetOption(eWhat, value);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "GL") == 0) {
            if (isStatic && strcmp(signature, "clearColor(_,_,_,_)") == 0) return C_clearColor;
            if (isStatic && strcmp(signature, "clear(_)") == 0)            return C_clear;
            if (isStatic && strcmp(signature, "shadeModel(_)") == 0)       return C_shadeModel;
            if (isStatic && strcmp(signature, "loadIdentity()") == 0)      return C_loadIdentity;
            if (isStatic && strcmp(signature, "translatef(_,_,_)") == 0)   return C_translatef;
            if (isStatic && strcmp(signature, "begin(_)") == 0)            return C_begin;
            if (isStatic && strcmp(signature, "color3f(_,_,_)") == 0)      return C_color3f;
            if (isStatic && strcmp(signature, "vertex2f(_,_)") == 0)       return C_vertex2f;
            if (isStatic && strcmp(signature, "end()") == 0)               return C_end;
            if (isStatic && strcmp(signature, "flush()") == 0)             return C_flush;
            if (isStatic && strcmp(signature, "viewport(_,_,_,_)") == 0)   return C_viewport;
            if (isStatic && strcmp(signature, "matrixMode(_)") == 0)       return C_matrixMode;
            if (isStatic && strcmp(signature, "ortho(_,_,_,_,_,_)") == 0)  return C_ortho;
        } else if (strcmp(className, "Glut") == 0) {
            if (isStatic && strcmp(signature, "initWindowSize(_,_)") == 0) return C_initWindowSize;
            if (isStatic && strcmp(signature, "createWindow(_)") == 0)     return C_createWindow;
            if (isStatic && strcmp(signature, "displayFunc(_,_)") == 0)    return C_displayFunc;
            if (isStatic && strcmp(signature, "reshapeFunc(_,_)") == 0)    return C_reshapeFunc;
            if (isStatic && strcmp(signature, "setOption(_,_)") == 0)      return C_setOption;
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
    glutInit(&argc, argv);
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "opengl.wren";
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
    glutMainLoop();
    wrenFreeVM(vm);
    free(script);
    return 0;
}
