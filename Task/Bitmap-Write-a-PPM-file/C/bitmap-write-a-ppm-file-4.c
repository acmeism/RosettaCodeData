#include "imglib.h"

void output_ppm(FILE *fd, image img)
{
  unsigned int n;
  (void) fprintf(fd, "P6\n%d %d\n255\n", img->width, img->height);
  n = img->width * img->height;
  (void) fwrite(img->buf, sizeof(pixel), n, fd);
  (void) fflush(fd);
}
