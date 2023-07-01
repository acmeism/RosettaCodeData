/* gcc -O3 -std=c11 -shared -o printer.so -fPIC  -I./include printer.c */

#include <stdlib.h>
#include <string.h>
#include "dome.h"

static DOME_API_v0* core;
static WREN_API_v0* wren;

static const char* source =  ""
"class Printer {\n"
  "foreign static printFile(name) \n"
"} \n";

void C_printFile(WrenVM* vm) {
    const char *arg = wren->getSlotString(vm, 1);
    char command[strlen(arg) + 4];
    strcpy(command, "lp ");
    strcat(command, arg);
    int res = system(command);
}

DOME_EXPORT DOME_Result PLUGIN_onInit(DOME_getAPIFunction DOME_getAPI, DOME_Context ctx) {
    core = DOME_getAPI(API_DOME, DOME_API_VERSION);
    wren = DOME_getAPI(API_WREN, WREN_API_VERSION);
    core->registerModule(ctx, "printer", source);
    core->registerClass(ctx, "printer", "Printer", NULL, NULL);
    core->registerFn(ctx, "printer", "static Printer.printFile(_)", C_printFile);
    return DOME_RESULT_SUCCESS;
}

DOME_EXPORT DOME_Result PLUGIN_preUpdate(DOME_Context ctx) {
    return DOME_RESULT_SUCCESS;
}

DOME_EXPORT DOME_Result PLUGIN_postUpdate(DOME_Context ctx) {
    return DOME_RESULT_SUCCESS;
}

DOME_EXPORT DOME_Result PLUGIN_preDraw(DOME_Context ctx) {
    return DOME_RESULT_SUCCESS;
}

DOME_EXPORT DOME_Result PLUGIN_postDraw(DOME_Context ctx) {
    return DOME_RESULT_SUCCESS;
}

DOME_EXPORT DOME_Result PLUGIN_onShutdown(DOME_Context ctx) {
    return DOME_RESULT_SUCCESS;
}
