#include "string.h"
#include "JNIDemo.h"

void throwByName(JNIEnv* env, const char* className, const char* msg)
{
  jclass exceptionClass = (*env)->FindClass(env, className);
  if (exceptionClass != NULL)
  {
    (*env)->ThrowNew(env, exceptionClass, msg);
    (*env)->DeleteLocalRef(env, exceptionClass);
  }
  return;
}

JNIEXPORT jstring JNICALL Java_JNIDemo_callStrdup(JNIEnv *env, jclass cls, jstring s)
{
  const jbyte* utf8String;
  char* dupe;
  jstring dupeString;

  if (s == NULL)
  {
    throwByName(env, "java/lang/NullPointerException", "String is null");
    return NULL;
  }

  // Convert from UTF-16 to UTF-8 (C-style)
  utf8String = (*env)->GetStringUTFChars(env, s, NULL);

  // Duplicate
  dupe = strdup(utf8String);

  // Free the UTF-8 string back to the JVM
  (*env)->ReleaseStringUTFChars(env, s, utf8String);

  // Convert the duplicate string from strdup to a Java String
  dupeString = (*env)->NewStringUTF(env, dupe);

  // Free the duplicate c-string back to the C runtime heap
  free(dupe);

  return dupeString;
}
