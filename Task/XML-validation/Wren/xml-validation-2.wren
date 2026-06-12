/* built with: gcc XML_validation.c -o XML_validation -I/usr/include/libxml2 -lxml2 -lwren -lm  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libxml2/libxml/xmlschemastypes.h>
#include "wren.h"

/* C <=> Wren interface functions */

char *xmlFilename, *xsdFilename;

void C_xmlFilename(WrenVM* vm) {
    wrenSetSlotString(vm, 0, xmlFilename);
}

void C_xsdFilename(WrenVM* vm) {
    wrenSetSlotString(vm, 0, xsdFilename);
}

void C_xmlSchemaPtrAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(xmlSchemaPtr));
}

void C_xmlSchemaParserCtxtPtrAllocate(WrenVM* vm) {
    xmlSchemaParserCtxtPtr* pctxt = (xmlSchemaParserCtxtPtr*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(xmlSchemaParserCtxtPtr));
    const char *url = wrenGetSlotString(vm, 1);
    *pctxt = xmlSchemaNewParserCtxt(url);
}

void C_xmlSchemaValidCtxtPtrAllocate(WrenVM* vm) {
    xmlSchemaValidCtxtPtr* pctxt = (xmlSchemaValidCtxtPtr*)wrenSetSlotNewForeign(vm, 0, 0, sizeof(xmlSchemaValidCtxtPtr));
    xmlSchemaPtr schema = *(xmlSchemaPtr*)wrenGetSlotForeign(vm, 1);
    *pctxt = xmlSchemaNewValidCtxt(schema);
}

void C_parse(WrenVM* vm) {
    xmlSchemaParserCtxtPtr ctxt = *(xmlSchemaParserCtxtPtr*)wrenGetSlotForeign(vm, 0);
    xmlSchemaPtr* pschema = (xmlSchemaPtr*)wrenGetSlotForeign(vm, 1);
    *pschema = xmlSchemaParse(ctxt);
}

void C_freeParserCtxt(WrenVM* vm) {
    xmlSchemaParserCtxtPtr ctxt = *(xmlSchemaParserCtxtPtr*)wrenGetSlotForeign(vm, 0);
    xmlSchemaFreeParserCtxt(ctxt);
}

void C_validateFile(WrenVM* vm) {
    xmlSchemaValidCtxtPtr ctxt = *(xmlSchemaValidCtxtPtr*)wrenGetSlotForeign(vm, 0);
    const char *filename = wrenGetSlotString(vm, 1);
    int options = (int)wrenGetSlotDouble(vm, 2);
    int res = xmlSchemaValidateFile(ctxt, filename, options);
    wrenSetSlotDouble(vm, 0, (double)res);
}

void C_freeValidCtxt(WrenVM* vm) {
    xmlSchemaValidCtxtPtr ctxt = *(xmlSchemaValidCtxtPtr*)wrenGetSlotForeign(vm, 0);
    xmlSchemaFreeValidCtxt(ctxt);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "XmlSchemaPtr") == 0) {
            methods.allocate = C_xmlSchemaPtrAllocate;
        } else if (strcmp(className, "XmlSchemaParserCtxtPtr") == 0) {
            methods.allocate = C_xmlSchemaParserCtxtPtrAllocate;
        } else if (strcmp(className, "XmlSchemaValidCtxtPtr") == 0) {
            methods.allocate = C_xmlSchemaValidCtxtPtrAllocate;
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
        if (strcmp(className, "Args") == 0) {
            if (isStatic && strcmp(signature, "xmlFilename") == 0) return C_xmlFilename;
            if (isStatic && strcmp(signature, "xsdFilename") == 0) return C_xsdFilename;
        } else if (strcmp(className, "XmlSchemaParserCtxtPtr") == 0) {
            if (!isStatic && strcmp(signature, "parse(_)") == 0) return C_parse;
            if (!isStatic && strcmp(signature, "freeParserCtxt()") == 0) return C_freeParserCtxt;
        } else if (strcmp(className, "XmlSchemaValidCtxtPtr") == 0) {
            if (!isStatic && strcmp(signature, "validateFile(_,_)") == 0) return C_validateFile;
            if (!isStatic && strcmp(signature, "freeValidCtxt()") == 0) return C_freeValidCtxt;
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
    if (argc <= 2) {
		printf("Usage: %s <XML Document Name> <XSD Document Name>\n", argv[0]);
		return 0;
	}
    xmlFilename = argv[1];
    xsdFilename = argv[2];
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignClassFn = &bindForeignClass;
    config.bindForeignMethodFn = &bindForeignMethod;
    WrenVM* vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "XML_validation.wren";
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
