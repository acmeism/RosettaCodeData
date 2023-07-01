# 20211226 Perl programming solution

use strict;
use warnings;

use Imager;

my $raw;

open my $fh, '-|', 'cat Lenna50.jpg' or die;
binmode $fh;
while ( sysread $fh , my $chunk , 1024 ) { $raw .= $chunk }
close $fh;

my $enable = $Imager::formats{"jpeg"}; # some kind of tie ?

my $IO = Imager::io_new_buffer $raw or die;
my $im = Imager::File::JPEG::i_readjpeg_wiol $IO or die;

open my $fh2, '>', 'output.ppm' or die;
binmode $fh2;
my $IO2 = Imager::io_new_fd(fileno $fh2);
Imager::i_writeppm_wiol $im, $IO2 ;
close $fh2;
undef($im);
