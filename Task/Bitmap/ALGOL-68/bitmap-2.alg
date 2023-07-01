#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

### The test program ###
PR READ "prelude/Bitmap.a68" PR;

test:(
   REF IMAGE x := INIT LOC[1:16, 1:16]PIXEL;
   (fill OF class image) (x, white OF class image);
   (print OF class image) (x)
)
