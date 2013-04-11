#include "imglib.h"

inline static color_component GET_PIXEL_CHECK(image img, int x, int y, int l) {
  if ( (x<0) || (x >= img->width) || (y<0) || (y >= img->height) ) return 0;
  return GET_PIXEL(img, x, y)[l];
}

image filter(image im, double *K, int Ks, double divisor, double offset)
{
  image oi;
  unsigned int ix, iy, l;
  int kx, ky;
  double cp[3];

  oi = alloc_img(im->width, im->height);
  if ( oi != NULL ) {
    for(ix=0; ix < im->width; ix++) {
      for(iy=0; iy < im->height; iy++) {
	cp[0] = cp[1] = cp[2] = 0.0;
	for(kx=-Ks; kx <= Ks; kx++) {
	  for(ky=-Ks; ky <= Ks; ky++) {
	    for(l=0; l<3; l++)
	      cp[l] += (K[(kx+Ks) +
                        (ky+Ks)*(2*Ks+1)]/divisor) *
                        ((double)GET_PIXEL_CHECK(im, ix+kx, iy+ky, l)) + offset;
	  }
	}
	for(l=0; l<3; l++)
	  cp[l] = (cp[l]>255.0) ? 255.0 : ((cp[l]<0.0) ? 0.0 : cp[l]) ;
	put_pixel_unsafe(oi, ix, iy,
			 (color_component)cp[0],
			 (color_component)cp[1],
			 (color_component)cp[2]);
      }
    }
    return oi;
  }
  return NULL;
}
