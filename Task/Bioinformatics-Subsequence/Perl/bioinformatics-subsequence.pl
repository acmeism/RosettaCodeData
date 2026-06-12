use strict;
use warnings;
use feature 'say';

my @bases = <A C G T>;
my $basecnt = 160;

my($string,$target);
$string .= $bases[ int rand @bases ] for 1 .. $basecnt;
$target .= $bases[ int rand @bases ] for 1 .. 4;
say "Target: $target";
say 'Matches at these positions:';
say (($string =~ s/.{1,40}\K/\n/gr) =~ s/($target)/ >$1< /gr);
