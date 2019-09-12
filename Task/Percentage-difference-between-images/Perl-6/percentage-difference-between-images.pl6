#!/usr/bin/env perl6

use v6;
use GD::Raw;

# Reference:
# https://github.com/dagurval/perl6-gd-raw

my $fh1 = fopen('./Lenna50.jpg', "rb") or die;
my $img1 = gdImageCreateFromJpeg($fh1);
my $fh2 = fopen('./Lenna100.jpg', "rb") or die;
my $img2 = gdImageCreateFromJpeg($fh2);

my $img1X = gdImageSX($img1);
my $img1Y = gdImageSY($img1);
my $img2X = gdImageSX($img2);
my $img2Y = gdImageSY($img2);

($img1X == $img2X and $img1Y == $img2Y) or die "Image dimensions must match.";

my $diff = 0;
my ($px1, $px2);
loop (my $i = 0; $i < $img1X; $i++) {
   loop (my $j = 0; $j < $img1Y; $j++) {

      $px1 = gdImageGetPixel($img1, $i, $j);
      $px2 = gdImageGetPixel($img2, $i, $j);

      $diff += abs(gdImageRed($img1, $px1) - gdImageRed($img2, $px2));
      $diff += abs(gdImageGreen($img1, $px1) - gdImageGreen($img2, $px2));
      $diff += abs(gdImageBlue($img1, $px1) - gdImageBlue($img2, $px2));
   }
}

say "%difference = ", $diff/($img1X*$img1Y*3*255)*100;

gdImageDestroy($img1);
gdImageDestroy($img2);
