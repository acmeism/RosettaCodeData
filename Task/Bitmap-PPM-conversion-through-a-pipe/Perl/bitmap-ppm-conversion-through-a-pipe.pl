# 20211224 Perl programming solution

use strict;
use warnings;

use Imager;
use Imager::Test 'test_image_raw';

my $img = test_image_raw();
my $IO  = Imager::io_new_bufchain();
Imager::i_writeppm_wiol($img, $IO) or die;
my $raw = Imager::io_slurp($IO) or die;

open my $fh, '|-', '/usr/local/bin/convert - -compress none output.jpg' or die;
binmode $fh;
syswrite $fh, $raw or die;
close $fh;
