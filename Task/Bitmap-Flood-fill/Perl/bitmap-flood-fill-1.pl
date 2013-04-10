#! /usr/bin/perl

use strict;
use Image::Imlib2;

my $img = Image::Imlib2->load("Unfilledcirc.jpg");
$img->set_color(0, 255, 0, 255);
$img->fill(100,100);
$img->save("filledcirc.jpg");
exit 0;
