/* github jsoftware/jsource 903-release-b */
/* link with -ldl */
#include <dlfcn.h>
#include "j.h"
int main() {
    void* jdll= dlopen("./libj.so", RTLD_LAZY);
    JST* jt= ((JInitType)dlsym(jdll, "JInit"))();
    JDoType jdo= dlsym(jdll,"JDo");
    jdo(jt, (C*)"('Hello, World!',10{a.) 1!:2<'/proc/self/fd/1'");
    exit(0);
}
