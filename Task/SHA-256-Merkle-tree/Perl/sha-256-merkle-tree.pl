# 20210222 Perl programming solution

use strict;
use warnings;

use Crypt::Digest::SHA256 'sha256' ;

my @blocks;

open my $fh, '<:raw', './title.png';

while ( read $fh, my $chunk, 1024 ) { push @blocks, sha256 $chunk }

while ( scalar @blocks > 1 ) {
   my @clone = @blocks and @blocks = ();
   while ( @_ = splice @clone, 0, 2 ) {
      push @blocks, scalar @_ == 1 ? $_[0] : sha256 $_[0].$_[1]
   }
}

print unpack ( 'H*', $blocks[0] ) , "\n";
