# 20211217 Perl programming solution

use strict;
use warnings;

use IO::Handle;
use File::Temp qw/ tempfile tempdir /;

my ($fh, $tempfile) = tempfile();
my $count = 0;

open $fh, '>', $tempfile or die;

print "\n\nOutput goes to $tempfile\n";

while (1) {
   sleep 1;
   print $fh "Sheep number ",$count++," just leaped over the fence ..\n";
   $fh->flush();
}
