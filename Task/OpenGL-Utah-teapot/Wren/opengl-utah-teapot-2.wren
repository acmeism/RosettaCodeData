#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <GL/gl.h>
#include <GL/freeglut.h>
#include "wren.h"

/* C <=> Wren interface functions */

WrenVM *vm;

const char *displayClass, *displayMethod, *idleClass, *idleMethod;

void display() {
    wrenEnsureSlots(vm, 1);
    wrenGetVariable(vm, "main", displayClass, 0);
    WrenHandle *method = wrenMakeCallHandle(vm, displayMethod);
    wrenCall(vm, method);
    wrenReleaseHandle(vm, method);
}

void idle() {
    wrenEnsureSlots(vm, 1);
    wrenGetVariable(vm, "main", idleClass, 0);
    WrenHandle *method = wrenMakeCallHandle(vm, idleMethod);
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

void C_pushMatrix(WrenVM* vm) {
    glPushMatrix();
}

void C_rotatef(WrenVM* vm) {
    GLdouble angle = (GLdouble)wrenGetSlotDouble(vm, 1);
    GLdouble x     = (GLdouble)wrenGetSlotDouble(vm, 2);
    GLdouble y     = (GLdouble)wrenGetSlotDouble(vm, 3);
    GLdouble z     = (GLdouble)wrenGetSlotDouble(vm, 4);
    glRotatef(angle, x, y, z);
}

void C_materialfv(WrenVM* vm) {
    GLenum face   = (GLenum)wrenGetSlotDouble(vm, 1);
    GLenum pname  = (GLenum)wrenGetSlotDouble(vm, 2);
    int count = wrenGetListCount(vm, 3);
    GLfloat params[count];
    int i;
    for (i = 0; i < count; ++i) {
        wrenGetListElement(vm, 3, i, 1);
        params[i] = (GLfloat)wrenGetSlotDouble(vm, 1);
    }
    glMaterialfv(face, pname, (const GLfloat*)params);
}

void C_popMatrix(WrenVM* vm) {
    glPopMatrix();
}

void C_flush(WrenVM* vm) {
    glFlush();
}

void C_lightfv(WrenVM* vm) {
    GLenum light  = (GLenum)wrenGetSlotDouble(vm, 1);
    GLenum pname  = (GLenum)wrenGetSlotDouble(vm, 2);
    int count = wrenGetListCount(vm, 3);
    GLfloat params[count];
    int i;
    for (i = 0; i < count; ++i) {
        wrenGetListElement(vm, 3, i, 1);
        params[i] = (GLfloat)wrenGetSlotDouble(vm, 1);
    }
    glLightfv(light, pname, (const GLfloat*)params);
}

void C_enable(WrenVM* vm) {
    GLenum cap = (GLenum)wrenGetSlotDouble(vm, 1);
    glEnable(cap);
}

void C_initDisplayMode(WrenVM* vm) {
    unsigned int mode = (unsigned int)wrenGetSlotDouble(vm, 1);
    glutInitDisplayMode(mode);
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

void C_idleFunc(WrenVM* vm) {
    idleClass  = wrenGetSlotString(vm, 1);
    idleMethod = wrenGetSlotString(vm, 2);
    glutIdleFunc(&idle);
}

void C_postRedisplay(WrenVM* vm) {
    glutPostRedisplay();
}

void C_wireTeapot(WrenVM* vm) {
    GLdouble dSize = (GLdouble)wrenGetSlotDouble(vm, 1);
    glutWireTeapot(dSize);
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
            if (isStatic && strcmp(signature, "pushMatrix()") == 0)        return C_pushMatrix;
            if (isStatic && strcmp(signature, "rotatef(_,_,_,_)") == 0)    return C_rotatef;
            if (isStatic && strcmp(signature, "materialfv(_,_,_)") == 0)   return C_materialfv;
            if (isStatic && strcmp(signature, "popMatrix()") == 0)         return C_popMatrix;
            if (isStatic && strcmp(signature, "flush()") == 0)             return C_flush;
            if (isStatic && strcmp(signature, "lightfv(_,_,_)") == 0)      return C_lightfv;
            if (isStatic && strcmp(signature, "enable(_)") == 0)           return C_enable;

        } else if (strcmp(className, "Glut") == 0) {
            if (isStatic && strcmp(signature, "initDisplayMode(_)") == 0)  return C_initDisplayMode;
            if (isStatic && strcmp(signature, "initWindowSize(_,_)") == 0) return C_initWindowSize;
            if (isStatic && strcmp(signature, "createWindow(_)") == 0)     return C_createWindow;
            if (isStatic && strcmp(signature, "displayFunc(_,_)") == 0)    return C_displayFunc;
            if (isStatic && strcmp(signature, "idleFunc(_,_)") == 0)       return C_idleFunc;
            if (isStatic && strcmp(signature, "postRedisplay()") == 0)     return C_postRedisplay;
            if (isStatic && strcmp(signature, "wireTeapot(_)") == 0)       return C_wireTeapot;
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
    const char* fileName = "OpenGL_Utah_teapot.wren";
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
