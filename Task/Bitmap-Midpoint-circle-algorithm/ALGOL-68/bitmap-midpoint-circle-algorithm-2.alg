#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

PR READ "prelude/Bitmap.a68" PR;
PR READ "prelude/Bitmap/Bresenhams_line_algorithm.a68" PR;
PR READ "prelude/Bitmap/Midpoint_circle_algorithm.a68" PR;

# The following illustrates use: #
(
   REF IMAGE x = INIT LOC [1:16, 1:16] PIXEL;
   (fill OF class image)(x, (white OF class image));
   (circle OF class image)(x, (8, 8), 5, (black OF class image));
   (print OF class image)(x)
)
