#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/* this should be the way we check if we can use posix/bsd strcasecmp */
#if !defined(_BSD_SOURCE) && !defined(_DEFAULT_SOURCE)
#include <ctype.h>
int strcasecmp(const char *s1, const char *s2) {
  for(; tolower(*s1) == tolower(*s2); ++s1, ++s2)
    if(*s1 == 0)
      return 0;
  return *(unsigned char *)s1 < *(unsigned char *)s2 ? -1 : 1;
}
#else
#include <strings.h>
#endif


bool ext_is_in_list(const char *filename, const char *extlist[])
{
  size_t i;

  const char *ext = strrchr(filename, '.');
  if (ext) {
    for (i = 0; extlist[i] != NULL; ++i) {
      if (strcasecmp(ext, extlist[i]) == 0)
	return true;
    }
  }

  return false;
}


// testing
const char *fnames[] = {
    "text.txt",
    "text.TXT",
    "test.tar.gz",
    "test/test2.exe",
    "test\\test2.exe",
    "test",
    "a/b/c\\d/foo",
    "foo.c",
    "foo.C",
    "foo.C++",
    "foo.c#",
    "foo.zkl",
    "document.pdf",
    NULL
};

const char *exts[] = {
    ".txt", ".gz", ".bat", ".c",
    ".c++", ".exe", ".pdf",
    NULL
};

int  main(void)
{
  size_t i;

  for (i = 0; fnames[i]; ++i) {
    printf("%s: %s\n", fnames[i],
	   ext_is_in_list(fnames[i], exts) ? "yes" : "no");
  }

  return 0;
}
