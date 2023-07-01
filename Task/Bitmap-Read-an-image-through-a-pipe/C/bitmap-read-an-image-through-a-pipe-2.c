#include "imglib.h"

#define MAXCMDBUF 100
#define MAXFILENAMELEN 256
#define MAXFULLCMDBUF (MAXCMDBUF + MAXFILENAMELEN)
image read_image(const char *name)
{
      FILE *pipe;
      char buf[MAXFULLCMDBUF];
      image im;

      FILE *test = fopen(name, "r");
      if ( test == NULL ) {
         fprintf(stderr, "cannot open file %s\n", name);
         return NULL;
      }
      fclose(test);

      snprintf(buf, MAXFULLCMDBUF, "convert \"%s\" ppm:-", name);
      pipe = popen(buf, "r");
      if ( pipe != NULL )
      {
           im = get_ppm(pipe);
           pclose(pipe);
           return im;
      }
      return NULL;
}
