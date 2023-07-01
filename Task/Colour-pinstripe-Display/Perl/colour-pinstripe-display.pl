use strict;
use warnings;
use GD;

my %colors = (
"white"   => [255,255,255], "red"    => [255,  0,  0], "green" => [  0,255,  0], "blue"  => [  0,  0,255],
"magenta" => [255,  0,255], "yellow" => [255,255,  0], "cyan"  => [  0,255,255], "black" => [  0,  0,  0]);

my($height, $width) = (240, 320);
my $image = GD::Image->new( $width , $height );

my @paintcolors;
my $barheight = $height / 4;
my($startx, $starty, $run, $colorindex) = (0) x 4;

for my $color ( sort keys %colors ) {
    push @paintcolors, $image->colorAllocate( @{$colors{ $color }} );
}

while ( $run < 4 ) {
    my $barwidth =  $run + 1;
    while ( $startx + $barwidth < $width ) {
        $image->filledRectangle( $startx, $starty,
                                 $startx + $barwidth,
                                 $starty + $barheight - 1,
                                 $paintcolors[ $colorindex % 8 ] );
        $startx += $barwidth;
        $colorindex++;
    }
    $starty    += $barheight;
    $startx     = 0;
    $colorindex = 0;
    $run++;
}

open ( DISPLAY , '>' , 'pinstripes.png' ) or die;
binmode DISPLAY;
print DISPLAY $image->png;
close DISPLAY;
