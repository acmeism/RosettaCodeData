#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

PR READ "prelude/Bitmap.a68" PR; # c.f. [[rc:Bitmap]] #
PR READ "prelude/Bitmap/Bresenhams_line_algorithm.a68" PR;

### The test program: ###
test:(
   REF IMAGE x = INIT LOC[1:16, 1:16]PIXEL;
   (fill OF class image)(x, white OF class image);
   (line OF class image)(x, ( 1, 8), ( 8,16), black OF class image);
   (line OF class image)(x, ( 8,16), (16, 8), black OF class image);
   (line OF class image)(x, (16, 8), ( 8, 1), black OF class image);
   (line OF class image)(x, ( 8, 1), ( 1, 8), black OF class image);
   (print OF class image)(x)
)
