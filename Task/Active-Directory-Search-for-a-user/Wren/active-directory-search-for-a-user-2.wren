#include <stdio.h>
#include <stdio_ext.h>
#include <stdlib.h>
#include <string.h>
#include <ldap.h>
#include "wren.h"

/* C <=> Wren interface functions */

void C_ldapMessageAllocate(WrenVM* vm) {
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(LDAPMessage*));
}

void C_msgfree(WrenVM* vm) {
    LDAPMessage* msg = *(LDAPMessage**)wrenGetSlotForeign(vm, 0);
    ldap_msgfree(msg);
}

void C_ldapAllocate(WrenVM* vm) {
    LDAP** pldap = (LDAP**)wrenSetSlotNewForeign(vm, 0, 0, sizeof(LDAP*));
    char *host = (char *)wrenGetSlotString(vm, 1);
    int port = (int)wrenGetSlotDouble(vm, 2);
    *pldap = ldap_init(host, port);
}

void C_simpleBindS(WrenVM* vm) {
    LDAP* ldap = *(LDAP**)wrenGetSlotForeign(vm, 0);
    const char *name = wrenGetSlotString(vm, 1);
    const char *password = wrenGetSlotString(vm, 2);
    ldap_simple_bind_s(ldap, name, password);
}

void C_searchS(WrenVM* vm) {
    LDAP* ldap = *(LDAP**)wrenGetSlotForeign(vm, 0);
    const char *base = wrenGetSlotString(vm, 1);
    int scope = (int)(ber_int_t)wrenGetSlotDouble(vm, 2);
    const char *filter = wrenGetSlotString(vm, 3);
    // no need to get attrs from slot 4 as we want all of them
    int attrsonly = (int)wrenGetSlotDouble(vm, 5);
    LDAPMessage** res = (LDAPMessage**)wrenGetSlotForeign(vm, 6);
    ldap_search_s(ldap, base, scope, filter, NULL, attrsonly, res);
}

void C_unbind(WrenVM* vm) {
    LDAP* ldap = *(LDAP**)wrenGetSlotForeign(vm, 0);
    ldap_unbind(ldap);
}

void C_getInput(WrenVM* vm) {
    int maxSize = (int)wrenGetSlotDouble(vm, 1) + 2;
    char input[maxSize];
    fgets(input, maxSize, stdin);
    __fpurge(stdin);
    input[strcspn(input, "\n")] = 0;
    wrenSetSlotString(vm, 0, (const char*)input);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.finalize = NULL;
    if (strcmp(className, "LDAP") == 0) {
        methods.allocate = C_ldapAllocate;
    } else if (strcmp(className, "LDAPMessage") == 0) {
        methods.allocate = C_ldapMessageAllocate;
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
        if (strcmp(className, "LDAP") == 0) {
            if (!isStatic && strcmp(signature, "simpleBindS(_,_)") == 0) return C_simpleBindS;
            if (!isStatic && strcmp(signature, "searchS(_,_,_,_,_,_)") == 0) return C_searchS;
            if (!isStatic && strcmp(signature, "unbind()") == 0) return C_unbind;
        } else if (strcmp(className, "LDAPMessage") == 0) {
            if (!isStatic && strcmp(signature, "msgfree()") == 0) return C_msgfree;
        } else if (strcmp(className, "C") == 0) {
            if (isStatic && strcmp(signature, "getInput(_)") == 0) return C_getInput;
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
    const char* fileName = "active_directory_search_for_user.wren";
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
