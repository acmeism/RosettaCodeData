/* gcc WebGL_rotating_F.c -o WebGL_rotating_F -lglut -lGLESv2 -lm -lwren */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <GLES2/gl2.h>
#include <GL/freeglut.h>
#include <unistd.h>
#include "wren.h"

/* Gl functions */

void C_bufferData(WrenVM* vm) {
    GLenum target = (GLenum)wrenGetSlotDouble(vm, 1);
    GLsizeiptr size = (GLsizeiptr)wrenGetSlotDouble(vm, 2);
    int count = wrenGetListCount(vm, 3);
    GLenum usage = (GLenum)wrenGetSlotDouble(vm, 4);
    float data[count];
    for (int i = 0; i < count; ++i) {
        wrenGetListElement(vm, 3, i, 1);
        data[i] = (float)wrenGetSlotDouble(vm, 1);
        if (size == 1) data[i] /= 255.0;
    }
    glBufferData(target, 4 * count, data, usage);
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

void C_getAttribLocation(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    const GLchar *name = (const GLchar *)wrenGetSlotString(vm, 2);
    GLint location = glGetAttribLocation(program, name);
    wrenSetSlotDouble(vm, 0, (double)location);
}

void C_getUniformLocation(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    const GLchar *name = (const GLchar *)wrenGetSlotString(vm, 2);
    GLint location = glGetUniformLocation(program, name);
    wrenSetSlotDouble(vm, 0, (double)location);
}

void C_genBuffers(WrenVM* vm) {
    GLsizei n = (GLsizei)wrenGetSlotDouble(vm, 1);
    int count = wrenGetListCount(vm, 2);
    GLuint buffers[count];
    glGenBuffers(n, buffers);
    for (int i = 0; i < count; ++i) {
        wrenSetSlotDouble(vm, 1, (double)buffers[i]);
        wrenSetListElement(vm, 2, i, 1);
    }
}

void C_bindBuffer(WrenVM* vm) {
    GLenum target = (GLenum)wrenGetSlotDouble(vm, 1);
    GLuint buffer = (GLuint)wrenGetSlotDouble(vm, 2);
    glBindBuffer(target, buffer);
}

void C_viewport(WrenVM* vm) {
    GLint x = (GLint)wrenGetSlotDouble(vm, 1);
    GLint y = (GLint)wrenGetSlotDouble(vm, 2);
    GLsizei width = (GLsizei)wrenGetSlotDouble(vm, 3);
    GLsizei height = (GLsizei)wrenGetSlotDouble(vm, 4);
    glViewport(x, y, width, height);
}

void C_clear(WrenVM* vm) {
    glClearColor(1, 1, 1, 1); // always clear to white background
    GLbitfield mask = (GLbitfield)wrenGetSlotDouble(vm, 1);
    glClear(mask);
}

void C_enable(WrenVM* vm) {
    GLenum cap = (GLenum)wrenGetSlotDouble(vm, 1);
    glEnable(cap);
}

void C_useProgram(WrenVM* vm) {
    GLuint program = (GLuint)wrenGetSlotDouble(vm, 1);
    glUseProgram(program);
}

void C_drawArrays(WrenVM* vm) {
    GLenum mode = (GLenum)wrenGetSlotDouble(vm, 1);
    GLint first = (GLint)wrenGetSlotDouble(vm, 2);
    GLsizei count = (GLsizei)wrenGetSlotDouble(vm, 3);
    glDrawArrays(mode, first, count);
}

void C_enableVertexAttribArray(WrenVM* vm) {
    GLuint index = (GLuint)wrenGetSlotDouble(vm, 1);
    glEnableVertexAttribArray(index);
}

void C_vertexAttribPtr(WrenVM* vm) {
    GLuint index = (GLuint)wrenGetSlotDouble(vm, 1);
    GLint size = (GLint)wrenGetSlotDouble(vm, 2);
    GLenum type = (GLenum)wrenGetSlotDouble(vm, 3);
    GLboolean normalized = (GLboolean)wrenGetSlotBool(vm, 4);
    GLsizei stride = (GLsizei)wrenGetSlotDouble(vm, 5);
    // assume for simplicity sixth parameter will always be 0
    glVertexAttribPointer(index, size, type, normalized, stride, 0);
}

void C_uniformMatrix4fv(WrenVM* vm) {
    GLint location = (GLint)wrenGetSlotDouble(vm, 1);
    GLsizei count = (GLsizei)wrenGetSlotDouble(vm, 2);
    GLboolean transpose = (GLboolean)wrenGetSlotBool(vm, 3);
    int len = wrenGetListCount(vm, 4);
    GLfloat value[len];
    for (int i = 0; i < len; ++i) {
        wrenGetListElement(vm, 4, i, 1);
        value[i] = (GLfloat)wrenGetSlotDouble(vm, 1);
    }
    glUniformMatrix4fv(location, count, transpose, value);
}

void C_flush(WrenVM* vm) {
    glFlush();
}

/* Glut functions */

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

void C_setOption(WrenVM* vm) {
    GLenum eWhat = (GLenum)wrenGetSlotDouble(vm, 1);
    int value    = (int)wrenGetSlotDouble(vm, 2);
    glutSetOption(eWhat, value);
}

/* C function */

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
        if (strcmp(className, "Gl") == 0) {
            if (isStatic && strcmp(signature, "bufferData(_,_,_,_)") == 0)     return C_bufferData;
            if (isStatic && strcmp(signature, "createShader(_)") == 0)         return C_createShader;
            if (isStatic && strcmp(signature, "shaderSource(_,_,_,_)") == 0)   return C_shaderSource;
            if (isStatic && strcmp(signature, "compileShader(_)") == 0)        return C_compileShader;
            if (isStatic && strcmp(signature, "createProgram()") == 0)         return C_createProgram;
            if (isStatic && strcmp(signature, "attachShader(_,_)") == 0)       return C_attachShader;
            if (isStatic && strcmp(signature, "linkProgram(_)") == 0)          return C_linkProgram;
            if (isStatic && strcmp(signature, "getAttribLocation(_,_)") == 0)  return C_getAttribLocation;
            if (isStatic && strcmp(signature, "getUniformLocation(_,_)") == 0) return C_getUniformLocation;
            if (isStatic && strcmp(signature, "genBuffers(_,_)") == 0)         return C_genBuffers;
            if (isStatic && strcmp(signature, "bindBuffer(_,_)") == 0)         return C_bindBuffer;
            if (isStatic && strcmp(signature, "viewport(_,_,_,_)") == 0)       return C_viewport;
            if (isStatic && strcmp(signature, "clear(_)") == 0)                return C_clear;
            if (isStatic && strcmp(signature, "enable(_)") == 0)               return C_enable;
            if (isStatic && strcmp(signature, "useProgram(_)") == 0)           return C_useProgram;
            if (isStatic && strcmp(signature, "drawArrays(_,_,_)") == 0)       return C_drawArrays;
            if (isStatic && strcmp(signature, "flush()") == 0)                 return C_flush;

            if (isStatic && strcmp(signature, "enableVertexAttribArray(_)") == 0)   return C_enableVertexAttribArray;
            if (isStatic && strcmp(signature, "vertexAttribPtr(_,_,_,_,_,_)") == 0) return C_vertexAttribPtr;
            if (isStatic && strcmp(signature, "uniformMatrix4fv(_,_,_,_)") == 0)    return C_uniformMatrix4fv;
        } else if (strcmp(className, "Glut") == 0) {
            if (isStatic && strcmp(signature, "initDisplayMode(_)") == 0)  return C_initDisplayMode;
            if (isStatic && strcmp(signature, "initWindowSize(_,_)") == 0) return C_initWindowSize;
            if (isStatic && strcmp(signature, "createWindow(_)") == 0)     return C_createWindow;
            if (isStatic && strcmp(signature, "setOption(_,_)") == 0)      return C_setOption;
        } else if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "usleep(_)") == 0)           return C_usleep;
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
    glutInit(&argc, argv);
    glutInitContextVersion(2, 0);
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    config.loadModuleFn = &loadModule;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "WebGL_rotating_F.wren";
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
