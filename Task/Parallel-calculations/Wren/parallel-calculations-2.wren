#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>
#include "wren.h"

#define NUM_VMS 4

WrenVM* vms[NUM_VMS]; // array of VMs

void doParallelCalcs() {
    int data[] = {12757923, 12878611, 12878893, 12757923, 15808973, 15780709, 197622519};
    int i, count, largest, largest_factor = 0;
    omp_set_num_threads(4);
    // we can share the same call and class handles amongst VMs
    WrenHandle* callHandle  = wrenMakeCallHandle(vms[0], "minPrimeFactor(_)");
    WrenHandle* callHandle2 = wrenMakeCallHandle(vms[0], "allPrimeFactors(_)");
    wrenEnsureSlots(vms[0], 1);
    wrenGetVariable(vms[0], "main", "C", 0);
    WrenHandle* classHandle = wrenGetSlotHandle(vms[0], 0);

    #pragma omp parallel for shared(largest_factor, largest)
    for (i = 0; i < 7; ++i) {
        int n = data[i];
        int vi = omp_get_thread_num(); // assign a VM (via its array index) for this number
        wrenEnsureSlots(vms[vi], 2);
        wrenSetSlotHandle(vms[vi], 0, classHandle);
        wrenSetSlotDouble(vms[vi], 1, (double)n);
        wrenCall(vms[vi], callHandle);
        int p = (int)wrenGetSlotDouble(vms[vi], 0);
        if (p > largest_factor) {
            largest_factor = p;
            largest = n;
            printf("Thread %d: found larger: %d of %d\n", vi, p, n);
        } else {
            printf("Thread %d: not larger:   %d of %d\n", vi, p, n);
        }
    }

    printf("\nLargest minimal prime factor: %d of %d\n", largest_factor, largest);
    printf("All prime factors for this number: ");
    wrenEnsureSlots(vms[0], 2);
    wrenSetSlotHandle(vms[0], 0, classHandle);
    wrenSetSlotDouble(vms[0], 1, (double)largest);
    wrenCall(vms[0], callHandle2);
    count = wrenGetListCount(vms[0], 0);
    for (i = 0; i < count; ++i) {
        wrenGetListElement(vms[0], 0, i, 1);
        printf("%d ", (int)wrenGetSlotDouble(vms[0], 1));
    }
    printf("\n");
    wrenReleaseHandle(vms[0], callHandle);
    wrenReleaseHandle(vms[0], callHandle2);
    wrenReleaseHandle(vms[0], classHandle);
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
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.loadModuleFn = &loadModule;
    const char* module = "main";
    const char* fileName = "parallel_calculations.wren";
    char *script = readFile(fileName);

    // config the VMs and interpret the script
    int i;
    for (i = 0; i < NUM_VMS; ++i) {
        vms[i] = wrenNewVM(&config);
        wrenInterpret(vms[i], module, script);
    }
    doParallelCalcs();
    for (i = 0; i < NUM_VMS; ++i) wrenFreeVM(vms[i]);
    free(script);
    return 0;
}
