use strict;
use warnings;
use GD;

my %colors = (
white   => [255,255,255], red    => [255,  0,  0], green => [  0,255,  0], blue  => [  0,  0,255],
magenta => [255,  0,255], yellow => [255,255,  0], cyan  => [  0,255,255], black => [  0,  0,  0]);

my $start    = 0;
my $barwidth = 160 / 8;
my $image    = GD::Image->new( 160 , 100 );

for my $rgb ( values %colors ) {
   $image->filledRectangle( $start * $barwidth , 0 , $start * $barwidth +
	                        $barwidth - 1 , 99 , $image->colorAllocate( @$rgb ) );
   $start++ ;
}
open ( DISPLAY , ">" , "bars.png" ) or die;
binmode DISPLAY;
print DISPLAY $image->png;
close DISPLAY;
