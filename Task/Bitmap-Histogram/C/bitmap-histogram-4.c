#include <stdio.h>
#include <stdlib.h>
#include "imglib.h"

/* usage example */

#define BLACK 0,0,0
#define WHITE 255,255,255

int main(int argc, char **argv)
{
    image color_img;
    grayimage g_img;
    histogram h;
    luminance T;
    unsigned int x, y;

    if ( argc < 2 )
    {
       fprintf(stderr, "histogram FILE\n");
       exit(1);
    }
    color_img = read_image(argv[1]);
    if ( color_img == NULL ) exit(1);
    g_img = tograyscale(color_img);
    h = get_histogram(g_img);
    if ( h != NULL )
    {
          T = histogram_median(h);

          for(x=0; x < g_img->width; x++)
          {
            for(y=0; y < g_img->height; y++)
            {
               if ( GET_LUM(g_img,x,y) < T )
               {
                   put_pixel_unsafe(color_img, x, y, BLACK);
               } else {
                   put_pixel_unsafe(color_img, x, y, WHITE);
               }
            }
          }
          output_ppm(stdout, color_img);
          /* print_jpg(color_img, 90); */
          free(h);
    }

    free_img((image)g_img);
    free_img(color_img);
}
