#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <GL/glew.h>
#include <GL/gl.h>
#include <GL/freeglut.h>
#include "wren.h"

/* C <=> Wren interface functions */

WrenVM *vm;

const char *idleClass, *idleMethod;

void idle() {
    wrenEnsureSlots(vm, 1);
    wrenGetVariable(vm, "main", idleClass, 0);
    WrenHandle *method = wrenMakeCallHandle(vm, idleMethod);
    wrenCall(vm, method);
    wrenReleaseHandle(vm, method);
}

void C_clear(WrenVM* vm) {
    GLbitfield mask = (GLbitfield)wrenGetSlotDouble(vm, 1);
    glClear(mask);
}

void C_uniform1f(WrenVM* vm) {
    GLint location = (GLint)wrenGetSlotDouble(vm, 1);
    GLfloat v0     = (GLfloat)wrenGetSlotDouble(vm, 2);
    glUniform1f(location, v0);
}

void C_loadIdentity(WrenVM* vm) {
    glLoadIdentity();
}

void C_rotatef(WrenVM* vm) {
    GLdouble angle = (GLdouble)wrenGetSlotDouble(vm, 1);
    GLdouble x     = (GLdouble)wrenGetSlotDouble(vm, 2);
    GLdouble y     = (GLdouble)wrenGetSlotDouble(vm, 3);
    GLdouble z     = (GLdouble)wrenGetSlotDouble(vm, 4);
    glRotatef(angle, x, y, z);
}

void C_begin(WrenVM* vm) {
    GLenum mode = (GLenum)wrenGetSlotDouble(vm, 1);
    glBegin(mode);
}

void C_vertex3f(WrenVM* vm) {
    GLfloat x = (GLfloat)wrenGetSlotDouble(vm, 1);
    GLfloat y = (GLfloat)wrenGetSlotDouble(vm, 2);
    GLfloat z = (GLfloat)wrenGetSlotDouble(vm, 3);
    glVertex3f(x, y, z);
}

void C_end(WrenVM* vm) {
    glEnd();
}

void C_createShader(WrenVM* vm) {
    GLenum shaderType = (GLenum)wrenGetSlotDouble(vm, 1);
    GLuint shader = glCreateShader(shaderType);
    wrenSetSlotDouble(vm, 0, (double)shader);
}

void C_shaderSource(WrenVM* vm) {
    GLuint shader = (GLuint)wrenGetSlotDouble(vm, 1);
    GLsizei count = (GLsizei)wrenGetSlotDouble(vm, 2);
    // assume for simplicity there will always be one shader string and the fourth parameter will be null
    const GLchar *string = (const GLchar *)wrenGetSlotString(vm, 3);
    glShaderSource(shader, count, &string, 0);
}

void C_compileShader(WrenVM* vm) {
    GLuint shader = (GLuint)wrenGetSlotDouble(vm, 1);
    glCompileShader(shader);
    // check shader compiled ok
    GLint shader_compiled;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &shader_compiled);
    if (shader_compiled != GL_TRUE) {
        GLsizei log_length = 0;
        GLchar message[1024];
        glGetShaderInfoLog(shader, 1024, &log_length, message);
        printf("%s\n", message);
    }
}

void C_createProgram(WrenVM* vm) {
    GLuint program = glCreateProgram();
    wrenSetSlotDouble(vm, 0, (double)program);
}

void C_attachShader(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    GLuint shader  = (GLuint)wrenGetSlotDouble(vm, 2);
    glAttachShader(program, shader);
}

void C_linkProgram(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    // check program linked ok
    glBindAttribLocation(program, 0, "position");
    glBindAttribLocation(program, 1, "texcoord");
    glBindAttribLocation(program, 2, "normal");
    glBindAttribLocation(program, 3, "color");
    glLinkProgram(program);
    GLint program_linked;
    glGetProgramiv(program, GL_LINK_STATUS, &program_linked);
    if (program_linked != GL_TRUE) {
        GLsizei log_length = 0;
        GLchar message[1024];
        glGetProgramInfoLog(program, 1024, &log_length, message);
        printf("%s\n", message);
    }
}

void C_useProgram(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    glUseProgram(program);
}

void C_getUniformLocation(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    const GLchar *name = (const GLchar *)wrenGetSlotString(vm, 2);
    GLint location = glGetUniformLocation(program, name);
    wrenSetSlotDouble(vm, 0, (double)location);
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

void C_swapBuffers(WrenVM* vm) {
    glutSwapBuffers();
}

void C_idleFunc(WrenVM* vm) {
    idleClass  = wrenGetSlotString(vm, 1);
    idleMethod = wrenGetSlotString(vm, 2);
    glutIdleFunc(&idle);
}

void C_setOption(WrenVM* vm) {
    GLenum eWhat = (GLenum)wrenGetSlotDouble(vm, 1);
    int value    = (int)wrenGetSlotDouble(vm, 2);
    glutSetOption(eWhat, value);
}

void C_init(WrenVM* vm) {
    glewInit();
}

void C_isSupported(WrenVM* vm) {
    const char *name = (const char *)wrenGetSlotString(vm, 1);
    GLboolean supported = glewIsSupported(name);
    wrenSetSlotBool(vm, 0, (bool)supported);
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "GL") == 0) {
            if (isStatic && strcmp(signature, "clear(_)") == 0)                return C_clear;
            if (isStatic && strcmp(signature, "uniform1f(_,_)") == 0)          return C_uniform1f;
            if (isStatic && strcmp(signature, "loadIdentity()") == 0)          return C_loadIdentity;
            if (isStatic && strcmp(signature, "rotatef(_,_,_,_)") == 0)        return C_rotatef;
            if (isStatic && strcmp(signature, "begin(_)") == 0)                return C_begin;
            if (isStatic && strcmp(signature, "vertex3f(_,_,_)") == 0)         return C_vertex3f;
            if (isStatic && strcmp(signature, "end()") == 0)                   return C_end;
            if (isStatic && strcmp(signature, "createShader(_)") == 0)         return C_createShader;
            if (isStatic && strcmp(signature, "shaderSource(_,_,_,_)") == 0)   return C_shaderSource;
            if (isStatic && strcmp(signature, "compileShader(_)") == 0)        return C_compileShader;
            if (isStatic && strcmp(signature, "createProgram()") == 0)         return C_createProgram;
            if (isStatic && strcmp(signature, "attachShader(_,_)") == 0)       return C_attachShader;
            if (isStatic && strcmp(signature, "linkProgram(_)") == 0)          return C_linkProgram;
            if (isStatic && strcmp(signature, "useProgram(_)") == 0)           return C_useProgram;
            if (isStatic && strcmp(signature, "getUniformLocation(_,_)") == 0) return C_getUniformLocation;
        } else if (strcmp(className, "Glut") == 0) {
            if (isStatic && strcmp(signature, "initDisplayMode(_)") == 0)      return C_initDisplayMode;
            if (isStatic && strcmp(signature, "initWindowSize(_,_)") == 0)     return C_initWindowSize;
            if (isStatic && strcmp(signature, "createWindow(_)") == 0)         return C_createWindow;
            if (isStatic && strcmp(signature, "swapBuffers()") == 0)           return C_swapBuffers;
            if (isStatic && strcmp(signature, "idleFunc(_,_)") == 0)           return C_idleFunc;
            if (isStatic && strcmp(signature, "setOption(_,_)") == 0)          return C_setOption;
        } else if (strcmp(className, "Glew") == 0) {
            if (isStatic && strcmp(signature, "init()") == 0)                  return C_init;
            if (isStatic && strcmp(signature, "isSupported(_)") == 0)          return C_isSupported;
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
    const char* fileName = "OpenGL_pixel_shader.wren";
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
