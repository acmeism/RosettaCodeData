/**
  ascii Mandelbrot using 16 bits of fixed point integer maths with a selectable fractional precision in bits.

  This is still only 16 bits mathc and allocating more than 6 bits of fractional precision leads to an overflow that adds noise to the plot..

  This code frequently casts to short to ensure we're not accidentally benefitting from GCC promotion from short 16 bits to int.

  gcc fixedPoint.c  -lm

 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <string.h>

short s(short i);
short toPrec(double f, int bitsPrecision);

int main(int argc, char* argv[])
{
  // chosen to match https://www.youtube.com/watch?v=DC5wi6iv9io
  int width = 32; // basic width of a zx81
  int height = 22; // basic width of a zx81
  int zoom=3;  // bigger with finer detail ie a smaller step size - leave at 1 for 32x22

  // params
  short bitsPrecision = 6;
  printf("PRECISION=%d\n", bitsPrecision);

  short X1 = toPrec(3.5,bitsPrecision) / zoom;
  short X2 = toPrec(2.25,bitsPrecision) ;
  short Y1 = toPrec(3,bitsPrecision)/zoom ;   // horiz pos
  short Y2 = toPrec(1.5,bitsPrecision) ; // vert pos
  short LIMIT = toPrec(4,bitsPrecision);


  // fractal
  //char * chr = ".:-=X$#@.";
  char * chr = "abcdefghijklmnopqr ";
  //char * chr = ".,'~=+:;[/<&?oxOX#.";
  short maxIters = strlen(chr);

  short py=0;
  while (py < height*zoom) {
    short px=0;
    while (px < width*zoom) {

      short x0 = s(s(px*X1) / width) - X2;
      short y0 = s(s(py*Y1) / height) - Y2;

      short x=0;
      short y=0;

      short i=0;

      short xSqr;
      short ySqr;
      while (i < maxIters) {
        xSqr = s(x * x) >> bitsPrecision;
        ySqr = s(y * y) >> bitsPrecision;

        // Breakout if sum is > the limit OR breakout also if sum is negative which indicates overflow of the addition has occurred
        // The overflow check is only needed for precisions of over 6 bits because for 7 and above the sums come out overflowed and negative therefore we always run to maxIters and we see nothing.
        // By including the overflow break out we can see the fractal again though with noise.
        if ((xSqr + ySqr) >= LIMIT || (xSqr+ySqr) < 0) {
          break;
        }

        short xt = xSqr - ySqr + x0;
        y = s(s(s(x * y) >> bitsPrecision) * 2) + y0;
        x=xt;

        i = i + 1;
      }
      i = i - 1;

      printf("%c", chr[i]);

      px = px + 1;
    }

    printf("\n");
    py = py + 1;
  }
}

// convert decimal value to a fixed point value in the given precision
short toPrec(double f, int bitsPrecision) {
  short whole = ((short)floor(f) << (bitsPrecision));
  short part = (f-floor(f))*(pow(2,bitsPrecision));
  short ret = whole + part;
  return ret;
}

// convenient casting
short s(short i) {
  return i;
}
