#include <stdio.h>

int main()
{
  const char *filename = "n.pgm";
  int x, y;
  /* size of the image */
  const int x_max = 100;  /* width */
  const int y_max = 100;  /* height */
  /* 2D array for colors (shades of gray) */
  unsigned char data[y_max][x_max];
  /* color component is coded from 0 to 255 ;  it is 8 bit color file */
  const int MaxColorComponentValue = 255;
  FILE * fp;
  /* comment should start with # */
  const char *comment = "# this is my new binary pgm file";

  /* fill the data array */
  for (y = 0; y < y_max; ++y) {
    for (x = 0; x < x_max; ++x) {
      data[y][x] = (x + y) & 255;
    }
  }

  /* write the whole data array to ppm file in one step */
  /* create new file, give it a name and open it in binary mode */
  fp = fopen(filename, "wb");
  /* write header to the file */
  fprintf(fp, "P5\n %s\n %d\n %d\n %d\n", comment, x_max, y_max,
          MaxColorComponentValue);
  /* write image data bytes to the file */
  fwrite(data, sizeof(data), 1, fp);
  fclose(fp);
  printf("OK - file %s saved\n", filename);
  return 0;
}
