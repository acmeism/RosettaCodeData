#include <stdio.h>
#include "imglib.h"

int main()
{
   image source;
   grayimage idest;

   source = get_ppm(stdin);
   idest = tograyscale(source);
   free_img(source);
   source = tocolor(idest);
   output_ppm(stdout, source);
   free_img(source); free_img((image)idest);
   return 0;
}
