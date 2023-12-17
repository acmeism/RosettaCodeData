#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Draw_a_pixel
use warnings;
use Tk;

my $mw = MainWindow->new;
my $canvas = $mw->Canvas( -width => 320, -height => 240 )->pack;
$canvas->createRectangle( 100, 100, 100, 100, -outline => 'red' );
MainLoop;
