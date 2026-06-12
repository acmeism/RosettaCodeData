#!/usr/bin/env perl6

use v6;
use GD::Raw;

# Reference:
# https://github.com/dagurval/perl6-gd-raw

my $fh1 = fopen('./Lenna100.jpg', "rb") or die;
my $img1 = gdImageCreateFromJpeg($fh1);

my $fh2 = fopen('./Lenna100-larger.jpg',"wb") or die;

my $img1X = gdImageSX($img1);
my $img1Y = gdImageSY($img1);

my $NewX = $img1X * 1.6;
my $NewY = $img1Y * 1.6;

gdImageSetInterpolationMethod($img1, +GD_BILINEAR_FIXED);

my $img2 = gdImageScale($img1, $NewX.ceiling, $NewY.ceiling);

gdImageJpeg($img2,$fh2,-1);

gdImageDestroy($img1);
gdImageDestroy($img2);

fclose($fh1);
fclose($fh2);
