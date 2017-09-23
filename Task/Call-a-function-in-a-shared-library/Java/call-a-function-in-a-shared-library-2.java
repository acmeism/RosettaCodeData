/* TrySort.c */

#include <stdlib.h>
#include "TrySort.h"

static void fail(JNIEnv *jenv, const char *error_name) {
    jclass error_class = (*jenv)->FindClass(jenv, error_name);
    (*jenv)->ThrowNew(jenv, error_class, NULL);
}

static int reverse_abs_cmp(const void *pa, const void *pb) {
    jint a = *(jint *)pa;
    jint b = *(jint *)pb;
    a = a > 0 ? -a : a;
    b = b > 0 ? -b : b;
    return a < b ? -1 : a > b ? 1 : 0;
}

void Java_TrySort_sortInC(JNIEnv *jenv, jclass obj, jintArray ary) {
    jint *elem, length;

    if (ary == NULL) {
	fail(jenv, "java/lang/NullPointerException");
	return;
    }
    length = (*jenv)->GetArrayLength(jenv, ary);
    elem = (*jenv)->GetPrimitiveArrayCritical(jenv, ary, NULL);
    if (elem == NULL) {
	fail(jenv, "java/lang/OutOfMemoryError");
	return;
    }
    qsort(elem, length, sizeof(jint), reverse_abs_cmp);
    (*jenv)->ReleasePrimitiveArrayCritical(jenv, ary, elem, 0);
}
