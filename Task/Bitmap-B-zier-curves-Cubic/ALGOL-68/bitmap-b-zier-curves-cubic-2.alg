#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

PR READ "prelude/Bitmap.a68" PR;
PR READ "prelude/Bitmap/Bresenhams_line_algorithm.a68" PR;
PR READ "prelude/Bitmap/Bezier_curves/Cubic.a68" PR;

### test program ###
(
   REF IMAGE x = INIT LOC[16,16]PIXEL;
   (fill OF class image)(x, (white OF class image));
   (cubic bezier OF class image)(x, (16, 1), (1, 4), (3, 16), (15, 11), (black OF class image), EMPTY);
   (print OF class image) (x)
)
