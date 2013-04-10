#include <stdio.h>
#include <stdlib.h>
#include "imglib.h"

int main(int argc, char **argv)
{
  image animage;
  rgb_color ic;
  rgb_color rc;

  if ( argc > 1 ) {
    animage = read_image(argv[1]);
    if ( animage != NULL ) {
      ic.red = 255; /* = 0; */
      ic.green = 255; /* = 0; */
      ic.blue = 255; /* = 0; */
      rc.red = 0;
      rc.green = 255;
      rc.blue = 0;
      floodfill(animage, 100, 100, &ic, &rc);
                   /*    150, 150 */
      print_jpg(animage, 90);
      free(animage);
    }
  }
  return 0;
}
