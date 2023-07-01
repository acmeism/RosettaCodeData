#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

int myopenimage(const char *in)
{
  static int handle=0;
  fprintf(stderr, "internal openimage opens %s...\n", in);
  return handle++;
}

int main()
{
  void *imglib;
  int (*extopenimage)(const char *);
  int imghandle;

  imglib = dlopen("./fakeimglib.so", RTLD_LAZY);
  if ( imglib != NULL ) {
    /* extopenimage = (int (*)(const char *))dlsym(imglib,...)
       "man dlopen" says that C99 standard leaves casting from
       "void *" to a function pointer undefined. The following is the
       POSIX.1-2003 workaround found in man */
    *(void **)(&extopenimage) = dlsym(imglib, "openimage");
    /* the following works with gcc, gives no warning even with
       -Wall -std=c99 -pedantic options... :D */
    /* extopenimage = dlsym(imglib, "openimage"); */
    imghandle = extopenimage("fake.img");
  } else {
    imghandle = myopenimage("fake.img");
  }
  printf("opened with handle %d\n", imghandle);
  /* ... */
  if (imglib != NULL ) dlclose(imglib);
  return EXIT_SUCCESS;
}
