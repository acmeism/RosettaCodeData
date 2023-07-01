#include <stdio.h>
#include "imglib.h"

const char *input = "Lenna100.jpg";
const char *output = "filtered_lenna%d.ppm";

double emboss_kernel[3*3] = {
  -2., -1.,  0.,
  -1.,  1.,  1.,
  0.,  1.,  2.,
};

double sharpen_kernel[3*3] = {
  -1.0, -1.0, -1.0,
  -1.0,  9.0, -1.0,
  -1.0, -1.0, -1.0
};
double sobel_emboss_kernel[3*3] = {
  -1., -2., -1.,
  0.,  0.,  0.,
  1.,  2.,  1.,
};
double box_blur_kernel[3*3] = {
  1.0, 1.0, 1.0,
  1.0, 1.0, 1.0,
  1.0, 1.0, 1.0,
};

double *filters[4] = {
  emboss_kernel, sharpen_kernel, sobel_emboss_kernel, box_blur_kernel
};
const double filter_params[2*4] = {
  1.0, 0.0,
  1.0, 0.0,
  1.0, 0.5,
  9.0, 0.0
};

int main()
{
  image ii, oi;
  int i;
  char lennanames[30];

  ii = read_image(input);
  if ( ii != NULL ) {
    for(i=0; i<4; i++) {
      sprintf(lennanames, output, i);
      oi = filter(ii, filters[i], 1, filter_params[2*i], filter_params[2*i+1]);
      if ( oi != NULL ) {
	FILE *outfh = fopen(lennanames, "w");
	if ( outfh != NULL ) {
	  output_ppm(outfh, oi);
	  fclose(outfh);
	} else { fprintf(stderr, "out err %s\n", output); }
	free_img(oi);
      } else { fprintf(stderr, "err creating img filters %d\n", i); }
    }
    free_img(ii);
  } else { fprintf(stderr, "err reading %s\n", input); }
}
