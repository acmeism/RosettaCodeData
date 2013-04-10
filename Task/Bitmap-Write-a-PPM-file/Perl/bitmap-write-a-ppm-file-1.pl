#! /usr/bin/perl

use strict;
use Image::Imlib2;

my $img = Image::Imlib2->new(100,100);
$img->set_color(100,200,0, 255);
$img->fill_rectangle(0,0,100,100);

$img->save("out0.ppm");
$img->save("out0.jpg");
$img->save("out0.png");

exit 0;
