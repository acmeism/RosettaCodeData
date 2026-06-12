# 20210506 Perl programming solution

use strict;
use warnings;
use utf8;
use Unicode::Collate 'sort';

my %seen;
binmode(STDOUT, ':encoding(utf8)');
map { s/(\X)/$seen{$1}++/egr }
   "133252abcdeeffd", "a6789798st", "yxcdfgxcyz", "AАΑSäaoö٥🤔👨‍👩‍👧‍👧";
my $uca = Unicode::Collate->new();
print $uca->sort ( grep { $seen{$_} == 1 } keys %seen )
