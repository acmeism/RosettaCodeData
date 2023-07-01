#include "imglib.h"

int main()
{
      image img;

      img = alloc_img(100,100);
      fill_img(img, 50, 20, 200);
      draw_line(img, 0, 0, 80, 80, 255, 0, 0);
      print_jpg(img, 75);
      free_img(img);
}
