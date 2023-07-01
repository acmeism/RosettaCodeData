use strict;
use warnings;

use Imager;

my $img = Imager->new;
$img->read(file => 'frog.png');
my $img16 = $img->to_paletted({ max_colors => 16});
$img16->write(file => "frog-16.png")
