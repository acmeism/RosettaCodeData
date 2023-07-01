/* gcc -O3 -std=c11 -shared -o pipeconv.so -fPIC  -I./include pipeconv.c */

#include <stdlib.h>
#include <string.h>
#include "dome.h"

static DOME_API_v0* core;
static WREN_API_v0* wren;

static const char* source =  ""
"class PipeConv {\n"
  "foreign static convert(from, to) \n"
"} \n";

void C_convert(WrenVM* vm) {
    const char *from = wren->getSlotString(vm, 1);
    const char *to = wren->getSlotString(vm, 2);
    char command[strlen(from) + strlen(to) + 10];
    strcpy(command, "convert ");
    strcat(command, from);
    strcat(command, " ");
    strcat(command, to);
    int res = system(command);
}

DOME_EXPORT DOME_Result PLUGIN_onInit(DOME_getAPIFunction DOME_getAPI, DOME_Context ctx) {
    core = DOME_getAPI(API_DOME, DOME_API_VERSION);
    wren = DOME_getAPI(API_WREN, WREN_API_VERSION);
    core->registerModule(ctx, "pipeconv", source);
    core->registerClass(ctx, "pipeconv", "PipeConv", NULL, NULL);
    core->registerFn(ctx, "pipeconv", "static PipeConv.convert(_,_)", C_convert);
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
