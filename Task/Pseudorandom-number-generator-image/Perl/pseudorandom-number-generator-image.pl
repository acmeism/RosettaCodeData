use strict;
use warnings;
use GD;

my $img = GD::Image->new(500, 500, 1);

for my $y (0..500) {
        for my $x (0..500) {
                my $color = $img->colorAllocate(rand 256, rand 256, rand 256);
                $img->setPixel($x, $y, $color);
        }
}

# using "use v5.38.0;" enables strict and warnings automatically and results with the following error (twice):
# These fail with strict and warnings enabled (Bareword filehandle "F" not allowed under 'no feature "bareword_filehandles"')
# open  F, "image500.png";
# print F  $img->png;

# Replace with (although the close is not required, it is a good habit):
open (my $fh, ">", "image500.png") or die "Can't open image500.png: $!";
print $fh $img->png;
close ($fh) or warn "Unable to close file handle associated with image500.png after writing: $!";
