/* gcc SOAP.c -o SOAP -lcurl -lwren -lm  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include "wren.h"

/* C <=> Wren interface functions */

char *url, *read_file, *write_file;

size_t write_data(void *ptr, size_t size, size_t nmeb, void *stream) {
    return fwrite(ptr, size, nmeb, stream);
}

size_t read_data(void *ptr, size_t size, size_t nmeb, void *stream) {
    return fread(ptr, size, nmeb, stream);
}

void C_url(WrenVM* vm) {
    wrenSetSlotString(vm, 0, url);
}

void C_readFile(WrenVM* vm) {
    wrenSetSlotString(vm, 0, read_file);
}

void C_writeFile(WrenVM* vm) {
    wrenSetSlotString(vm, 0, write_file);
}

void C_fileAllocate(WrenVM* vm) {
    FILE** fp = (FILE**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(FILE*));
    const char *filename = wrenGetSlotString(vm, 1);
    const char *mode = wrenGetSlotString(vm, 2);
    *fp = fopen(filename, mode);
}

void C_curlSlistAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(struct curl_slist*));
}

void C_curlAllocate(WrenVM* vm) {
    CURL** pcurl = (CURL**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(CURL*));
    *pcurl = curl_easy_init();
}

void C_append(WrenVM* vm) {
    struct curl_slist** plist = (struct curl_slist**)wrenGetSlotForeign(vm, 0);
    const char *s = wrenGetSlotString(vm, 1);
    *plist = curl_slist_append(*plist, s);
}

void C_easyPerform(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    curl_easy_perform(curl);
}

void C_easyCleanup(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    curl_easy_cleanup(curl);
}

void C_easySetOpt(WrenVM* vm) {
    CURL* curl = *(CURL**)wrenGetSlotForeign(vm, 0);
    CURLoption opt = (CURLoption)wrenGetSlotDouble(vm, 1);
    if (opt < 10000) {
        long lparam = (long)wrenGetSlotDouble(vm, 2);
        curl_easy_setopt(curl, opt, lparam);
    } else if (opt < 20000) {
        if (opt == CURLOPT_WRITEDATA || opt == CURLOPT_READDATA) {
            FILE *fp = *(FILE**)wrenGetSlotForeign(vm, 2);
            curl_easy_setopt(curl, opt, fp);
        } else if (opt == CURLOPT_URL) {
            const char *url = wrenGetSlotString(vm, 2);
            curl_easy_setopt(curl, opt, url);
        } else if (opt == CURLOPT_HTTPHEADER) {
            struct curl_slist* header = *(struct curl_slist**)wrenGetSlotForeign(vm, 2);
            curl_easy_setopt(curl, opt, header);
        }
    } else if (opt < 30000) {
        if (opt == CURLOPT_READFUNCTION) {
            curl_easy_setopt(curl, opt, &read_data);
        } else if (opt == CURLOPT_WRITEFUNCTION) {
            curl_easy_setopt(curl, opt, &write_data);
        }
    } else {
        curl_off_t cparam = (curl_off_t)wrenGetSlotDouble(vm, 2);
        curl_easy_setopt(curl, opt, cparam);
    }
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "File") == 0) {
            methods.allocate = C_fileAllocate;
        } else if (strcmp(className, "CurlSlist") == 0) {
            methods.allocate = C_curlSlistAllocate;
        } else if (strcmp(className, "Curl") == 0) {
            methods.allocate = C_curlAllocate;
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
        if (strcmp(className, "File") == 0) {
            if (isStatic && strcmp(signature, "url") == 0)              return C_url;
            if (isStatic && strcmp(signature, "readFile") == 0)         return C_readFile;
            if (isStatic && strcmp(signature, "writeFile") == 0)        return C_writeFile;
        } else if (strcmp(className, "CurlSlist") == 0) {
            if (!isStatic && strcmp(signature, "append(_)") == 0)       return C_append;
        } else if (strcmp(className, "Curl") == 0) {
            if (!isStatic && strcmp(signature, "easySetOpt(_,_)") == 0) return C_easySetOpt;
            if (!isStatic && strcmp(signature, "easyPerform()") == 0)   return C_easyPerform;
            if (!isStatic && strcmp(signature, "easyCleanup()") == 0)   return C_easyCleanup;
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
    if (argc != 4 ) {
		printf("Usage : %s <URL of WSDL> <Input file path> <Output file path>", argv[0]);
		return 0;
	}
    url = argv[1];
    read_file = argv[2];
    write_file = argv[3];
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignClassFn = &bindForeignClass;
    config.bindForeignMethodFn = &bindForeignMethod;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "SOAP.wren";
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
