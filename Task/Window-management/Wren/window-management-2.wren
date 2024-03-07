/* gcc `pkg-config --cflags gtk+-3.0` -DGDK_VERSION_MIN_REQIRED=GDK_VERSION_3_2 Window_management.c -o Window_management `pkg-config --libs gtk+-3.0` -lwren -lm */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <gtk/gtk.h>
#include <unistd.h>
#include "wren.h"

/* C <=> Wren interface functions */

WrenVM *vm;

static void btnClicked(GtkWidget *button, gpointer user_data) {
    const gchar *label = gtk_button_get_label(GTK_BUTTON(button));
    wrenEnsureSlots(vm, 2);
    wrenGetVariable(vm, "main", "GtkCallbacks", 0);
    WrenHandle *method = wrenMakeCallHandle(vm, "btnClicked(_)");
    wrenSetSlotString(vm, 1, (const char *)label);
    wrenCall(vm, method);
    wrenReleaseHandle(vm, method);
}

void C_gtkWindowAllocate(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenSetSlotNewForeign(vm, 0, 0, sizeof(GtkWidget*));
    GtkWindowType type = (GtkWindowType)wrenGetSlotDouble(vm, 1);
    *window = gtk_window_new(type);
}

void C_gtkButtonBoxAllocate(WrenVM* vm) {
    GtkWidget **buttonBox = (GtkWidget **)wrenSetSlotNewForeign(vm, 0, 0, sizeof(GtkWidget*));
    GtkOrientation orientation = (GtkOrientation)wrenGetSlotDouble(vm, 1);
    *buttonBox = gtk_button_box_new(orientation);
}

void C_gtkButtonAllocate(WrenVM* vm) {
    GtkWidget **button = (GtkWidget **)wrenSetSlotNewForeign(vm, 0, 0, sizeof(GtkWidget*));
    const gchar *label = (const gchar *)wrenGetSlotString(vm, 1);
    *button = gtk_button_new_with_label(label);
}

void C_setTitle(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    const gchar *title = (const gchar *)wrenGetSlotString(vm, 1);
    gtk_window_set_title(GTK_WINDOW(*window), title);
}

void C_setDefaultSize(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gint width = (gint)wrenGetSlotDouble(vm, 1);
    gint height = (gint)wrenGetSlotDouble(vm, 2);
    gtk_window_set_default_size(GTK_WINDOW(*window), width, height);
}

void C_add(WrenVM* vm) {
    GtkWidget **container = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    GtkWidget **widget = (GtkWidget **)wrenGetSlotForeign(vm, 1);
    gtk_container_add(GTK_CONTAINER(*container), *widget);
}

void C_connectDestroy(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    g_signal_connect(*window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
}

void C_showAll(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_widget_show_all(*window);
}

void C_iconify(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_window_iconify(GTK_WINDOW(*window));
}

void C_deiconify(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_window_deiconify(GTK_WINDOW(*window));
}

void C_maximize(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_window_maximize(GTK_WINDOW(*window));
}

void C_unmaximize(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_window_unmaximize(GTK_WINDOW(*window));
}

void C_move(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gint x = (gint)wrenGetSlotDouble(vm, 1);
    gint y = (gint)wrenGetSlotDouble(vm, 2);
    gtk_window_move(GTK_WINDOW(*window), x, y);
}

void C_resize(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gint width  = (gint)wrenGetSlotDouble(vm, 1);
    gint height = (gint)wrenGetSlotDouble(vm, 2);
    gtk_window_resize(GTK_WINDOW(*window), width, height);
}

void C_hide(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_widget_hide(*window);
}

void C_destroy(WrenVM* vm) {
    GtkWidget **window = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gtk_widget_destroy(*window);
}

void C_setSpacing(WrenVM* vm) {
    GtkWidget **buttonBox = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    gint spacing = (gint)wrenGetSlotDouble(vm, 1);
    gtk_box_set_spacing(GTK_BOX(*buttonBox), spacing);
}

void C_setLayout(WrenVM* vm) {
    GtkWidget **buttonBox = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    GtkButtonBoxStyle layoutStyle = (GtkButtonBoxStyle)wrenGetSlotDouble(vm, 1);
    gtk_button_box_set_layout(GTK_BUTTON_BOX(*buttonBox), layoutStyle);
}

void C_connectClicked(WrenVM* vm) {
    GtkWidget **button = (GtkWidget **)wrenGetSlotForeign(vm, 0);
    g_signal_connect(*button, "clicked", G_CALLBACK(btnClicked), NULL);
}

void C_flush(WrenVM* vm) {
    gdk_display_flush(gdk_display_get_default());
}

void C_sleep(WrenVM* vm) {
    unsigned int secs = (unsigned int)wrenGetSlotDouble(vm, 1);
    sleep(secs);
}

WrenForeignClassMethods bindForeignClass(WrenVM* vm, const char* module, const char* className) {
    WrenForeignClassMethods methods;
    methods.allocate = NULL;
    methods.finalize = NULL;
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "GtkWindow") == 0) {
            methods.allocate = C_gtkWindowAllocate;
        } else if (strcmp(className, "GtkButtonBox") == 0) {
            methods.allocate = C_gtkButtonBoxAllocate;
        } else if (strcmp(className, "GtkButton") == 0) {
            methods.allocate = C_gtkButtonAllocate;
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
        if (strcmp(className, "GtkWindow") == 0) {
            if (!isStatic && strcmp(signature, "title=(_)") == 0)           return C_setTitle;
            if (!isStatic && strcmp(signature, "setDefaultSize(_,_)") == 0) return C_setDefaultSize;
            if (!isStatic && strcmp(signature, "add(_)") == 0)              return C_add;
            if (!isStatic && strcmp(signature, "connectDestroy()") == 0)    return C_connectDestroy;
            if (!isStatic && strcmp(signature, "showAll()") == 0)           return C_showAll;
            if (!isStatic && strcmp(signature, "iconify()") == 0)           return C_iconify;
            if (!isStatic && strcmp(signature, "deiconify()") == 0)         return C_deiconify;
            if (!isStatic && strcmp(signature, "maximize()") == 0)          return C_maximize;
            if (!isStatic && strcmp(signature, "unmaximize()") == 0)        return C_unmaximize;
            if (!isStatic && strcmp(signature, "move(_,_)") == 0)           return C_move;
            if (!isStatic && strcmp(signature, "resize(_,_)") == 0)         return C_resize;
            if (!isStatic && strcmp(signature, "hide()") == 0)              return C_hide;
            if (!isStatic && strcmp(signature, "destroy()") == 0)           return C_destroy;
        } else if (strcmp(className, "GtkButtonBox") == 0) {
            if (!isStatic && strcmp(signature, "spacing=(_)") == 0)         return C_setSpacing;
            if (!isStatic && strcmp(signature, "layout=(_)") == 0)          return C_setLayout;
            if (!isStatic && strcmp(signature, "add(_)") == 0)              return C_add;
        } else if (strcmp(className, "GtkButton") == 0) {
           if (!isStatic && strcmp(signature, "connectClicked()") == 0)     return C_connectClicked;
        } else if (strcmp(className, "Gdk") == 0) {
           if (isStatic && strcmp(signature, "flush()") == 0)               return C_flush;
        } else if (strcmp(className, "C") == 0) {
           if (isStatic && strcmp(signature, "sleep(_)") == 0)              return C_sleep;
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
    gtk_init(&argc, &argv);
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignClassFn = &bindForeignClass;
    config.bindForeignMethodFn = &bindForeignMethod;
    vm = wrenNewVM(&config);
    const char* module = "main";
    const char* fileName = "Window_management.wren";
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
    gtk_main();
    wrenFreeVM(vm);
    free(script);
    return 0;
}
