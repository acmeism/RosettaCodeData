/* query-jni.c */
#include <stdio.h>
#include <stdlib.h>
#include <jni.h>

static JavaVM *jvm = NULL;
static JNIEnv *jenv = NULL;

static void die(const char *message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
}

static void oom(void) {
    die("Query: out of memory");
}

static void except(void) {
    if ((*jenv)->ExceptionCheck(jenv))
	die("Query: unexpected Java exception");
}

static void do_at_exit(void) {
    (*jvm)->DestroyJavaVM(jvm);
}

static void require_jvm(void) {
    JavaVMInitArgs args;

    if (jvm)
	return;

    args.version = JNI_VERSION_1_4;
    args.nOptions = 0;
    args.options = NULL;
    args.ignoreUnrecognized = JNI_FALSE;
    if (JNI_CreateJavaVM(&jvm, (void **)&jenv, &args) != JNI_OK)
	die("Query: can't create Java VM");
    atexit(do_at_exit);
}

int Query(char *data, size_t *length) {
    jclass cQuery;
    jmethodID mcall;
    jintArray jlength;
    jint jlength0;
    jbyteArray jdata;
    jboolean result;

    jlength0 = (jint)length[0];
    if ((size_t)jlength0 != length[0])
	die("Query: length is too large for Java array");

    require_jvm();

    /* Create a local frame for references to Java objects. */
    if ((*jenv)->PushLocalFrame(jenv, 16))
	oom();

    /* Look for class Query, static boolean call(byte[], int[]) */
    cQuery = (*jenv)->FindClass(jenv, "Query");
    if (cQuery == NULL)
	die("Query: can't find Query.class");
    mcall = (*jenv)->GetStaticMethodID(jenv, cQuery, "call", "([B[I)Z");
    if (mcall == NULL)
	die("Query: missing call() method");

    /*
     * Make arguments to Query.call().  We can't pass data[] and
     * length[] to Java, so we make new Java arrays jdata[] and
     * jlength[].
     */
    jdata = (*jenv)->NewByteArray(jenv, (jsize)jlength0);
    if (jdata == NULL)
	oom();
    jlength = (*jenv)->NewIntArray(jenv, 1);
    if (jlength == NULL)
	oom();

    /* Set jlength[0] = length[0]. */
    (*jenv)->SetIntArrayRegion(jenv, jlength, 0, 1, &jlength0);
    except();

    /*
     * Call our Java method.
     */
    result = (*jenv)->CallStaticBooleanMethod
	(jenv, cQuery, mcall, jdata, jlength);
    except();

    /*
     * Set length[0] = jlength[0].
     * Copy length[0] bytes from jdata[] to data[].
     */
    (*jenv)->GetIntArrayRegion(jenv, jlength, 0, 1, &jlength0);
    except();
    length[0] = (size_t)jlength0;
    (*jenv)->GetByteArrayRegion
	(jenv, jdata, 0, (jsize)jlength0, (jbyte *)data);

    /* Drop our local frame and its references. */
    (*jenv)->PopLocalFrame(jenv, NULL);

    return (int)result;
}
